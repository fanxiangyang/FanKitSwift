//
//  FanAuthManager.swift
//  FanKitSwift
//
//  Created by 凡向阳 on 2025/11/3.
//

import Foundation
import Photos
import UIKit


/// 权限管理类 - 回调不保证在主线程

@objcMembers public class FanAuthManager:NSObject{
    nonisolated(unsafe) static let shared = FanAuthManager()
    private override init() {}

    // MARK: - 相册权限

    /// 请求相册读写权限
    /// - Parameter albumBlock: （-2 用户点击不允许  -1本来就没有权限  0- 询问  1允许）
    public class func requestAlbumAuthorizationBlock(_ albumBlock: ((Int) -> Void)?) {
        let photoAuthorStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus()
        }
        if photoAuthorStatus == .denied || photoAuthorStatus == .restricted {
            albumBlock?(-1)
        } else if photoAuthorStatus == .notDetermined {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    
                    if status == .authorized || status == .limited {
                        albumBlock?(1)
                    } else {
                        albumBlock?(-2)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        albumBlock?(1)
                    } else {
                        albumBlock?(-2)
                    }
                }
            }
            albumBlock?(0)
        } else {
            albumBlock?(1)
        }
    }

    /// 当前相册读写权限（ -1本来就没有权限  0- 询问  1允许）
    public static func albumAuthorizationStatus() -> Int {
        let photoAuthorStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus()
        }
        if photoAuthorStatus == .denied || photoAuthorStatus == .restricted {
            return -1
        } else if photoAuthorStatus == .notDetermined {
            return 0
        } else {
            return 1
        }
    }

    /// 请求相册写权限（iOS14+）
    /// - Parameter albumBlock: （-2 用户点击不允许  -1本来就没有权限  0- 询问  1允许）
    public static func requestAlbumAuthorizationOnlyWriteBlock(_ albumBlock: ((Int) -> Void)?) {
        let photoAuthorStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        } else {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus()
        }
        if photoAuthorStatus == .denied || photoAuthorStatus == .restricted {
            albumBlock?(-1)
        } else if photoAuthorStatus == .notDetermined {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    if status == .authorized || status == .limited {
                        albumBlock?(1)
                    } else {
                        albumBlock?(-2)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        albumBlock?(1)
                    } else {
                        albumBlock?(-2)
                    }
                }
            }
            albumBlock?(0)
        } else {
            albumBlock?(1)
        }
    }

    /// 当前相册（只有写）权限iOS14+（ -1本来就没有权限  0- 询问  1允许）
    public static func albumAuthorizationStatusOnlyWrite() -> Int {
        let photoAuthorStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        } else {
            photoAuthorStatus = PHPhotoLibrary.authorizationStatus()
        }
        if photoAuthorStatus == .denied || photoAuthorStatus == .restricted {
            return -1
        } else if photoAuthorStatus == .notDetermined {
            return 0
        } else {
            return 1
        }
    }

    /// 保存到相册-图片UIImage、视频NSString
    /// - Parameters:
    ///   - data: UIImage、String、URL
    ///   - isImage: 是否是图片还是视频
    ///   - completion: （isSuccess=成功、失败，identifier=相册标识符）
    public static func saveToAlbum(_ data: Any, isImage: Bool, completion: ((Bool, String?) -> Void)?) {
        var saveImage: UIImage?
        var saveUrl: URL?
        if let image = data as? UIImage {
            saveImage = image
        } else if let path = data as? String {
            saveUrl = URL(fileURLWithPath: path)
        } else if let url = data as? URL {
            saveUrl = url
        } else {
            completion?(false, "data Type error")
            return
        }
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            var assetChangeRequest: PHAssetChangeRequest?
            if isImage {
                if let image = saveImage {
                    assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                } else if let url = saveUrl {
                    assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
                }
            } else {
                if let url = saveUrl {
                    assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }
            }
            placeholder = assetChangeRequest?.placeholderForCreatedAsset
        }, completionHandler: { success, error in
            let identifier = placeholder?.localIdentifier
            if success {
                completion?(true, identifier)
            } else if let error = error {
                completion?(false, error.localizedDescription)
            }
        })
    }

    // MARK: - 相机麦克风权限

    /// 请求相机权限
    /// - Parameter avBlock: 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
    public static func requestAVAuthorizationBlock(_ avBlock: ((Int) -> Void)?) {
        requestAVAuthorizationWithMediaType(.video, avBlock: avBlock)
    }

    /// 请求相机麦克风权限
    /// - Parameters:
    ///   - mediaType: 相机和麦克风 AVMediaType.video/AVMediaType.audio
    ///   - avBlock: 【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
    public static func requestAVAuthorizationWithMediaType(_ mediaType: AVMediaType, avBlock: ((Int) -> Void)?) {
        let deviceStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        if deviceStatus == .restricted || deviceStatus == .denied {
            avBlock?(-1)
        } else if deviceStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                if granted {
                    avBlock?(1)
                } else {
                    avBlock?(-2)
                }
            }
            avBlock?(0)
        } else {
            avBlock?(1)
        }
    }

    /// 请求相机麦克风权限【-1=不允许 -2 =用户点击不允许 0 = 弹窗询问 1=允许】
    /// - Parameter mediaType: 相机和麦克风 AVMediaType.video/AVMediaType.audio
    public static func avAuthorizationStatusWithMediaType(_ mediaType: AVMediaType) -> Int {
        let deviceStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        if deviceStatus == .restricted || deviceStatus == .denied {
            return -1
        } else if deviceStatus == .notDetermined {
            return 0
        } else {
            return 1
        }
    }

    // MARK: - 定位权限状态

    /// 获取当前定位权限 0=询问 1=允许  -1服务关闭 -2=不允许 -3=无法授权
    public static func locationAuthorizationStatus() -> Int {
        if !CLLocationManager.locationServicesEnabled() {
            return -1
        } else {
            let status:CLAuthorizationStatus
            if #available(iOS 14.0,*) {
                status = CLLocationManager().authorizationStatus
            }else{
                status = CLLocationManager.authorizationStatus()
            }
            if status == .denied {
                return -2
            } else if status == .restricted {
                return -3
            } else if status == .notDetermined {
                return 0
            } else {
                return 1
            }
        }
    }
}
