//
//  FanPlayer.swift
//  
//
//  Created by 凡向阳 on 2024/3/27.
//

import Foundation
import UIKit
import AVFoundation
///视频播放的View层
@objcMembers public class FanPlayerView: UIView {
    ///视频播放的层
    public private(set) var playerLayer:AVPlayerLayer?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    ///添加播放layer
    public func addPlayerLayer(layer:AVPlayerLayer?) {
        guard let layer = layer else {
            return
        }
        playerLayer?.removeFromSuperlayer()
        playerLayer = layer;
        playerLayer?.contentsScale = FanUIKitTool.fan_mainScreen().scale
        self.layer.insertSublayer(layer, at: 0)
        setNeedsLayout()
    }
    public func removePlayerLayer(){
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
}
///视频播放的支持Swift6了，但是版本限制iOS13.0
@available(iOS 13.0, *)
@MainActor @objcMembers public class FanPlayer:NSObject ,@unchecked Sendable{
    ///播放视频的View-需要提前初始化
    public weak var playerView:FanPlayerView?
    ///初始化View
    public init(playerView: FanPlayerView? = nil,videoGravity:AVLayerVideoGravity = .resizeAspect) {
        self.playerView = playerView
        self.videoGravity = videoGravity
    }
    ///默认播放视频，可以选播放音频
    public var playAudio:Bool = false
    /// 视频填充方式 默认等比适配进去
    public var videoGravity:AVLayerVideoGravity {
        didSet {
            self.playerLayer?.videoGravity = videoGravity
        }
    }
    
    /// 播放器
    public private(set) var avPlayer:AVPlayer?
    /// 播放器Layer
    public private(set) var playerLayer:AVPlayerLayer?
//    private(set) var playerItem:AVPlayerItem?
    ///state=0开始加载  =1已经播放  =2 播放完成
    public private(set) var playState:Int = 0 {
        didSet {
            if oldValue != playState {
                stateBlock?(playState)
                if loopPlay && playState == 2 {
                    rePlay()
                }
            }
        }
    }
    private var timeObser:Any?
    ///是否循环播放
    public var loopPlay:Bool = false
    /// 是否已经添加监听
    private var isPlayerObserver = false
    
    /// 加载进度
    public var loadedCacheBlock:((Double) -> Void)?
    /// 播放进度
    public var progressBlock:((Double) -> Void)?
    /// 播放状态 0开始加载  =1已经播放  =2 播放完成
    public var stateBlock:((Int) -> Void)?

    ///播放网络视频
    public func play(urlPath:String) {
        // 检测连接是否存在 不存在报错
        guard let url = URL(string: urlPath) else {
//            fatalError("这是一个中断，后面不执行")
//            assert(url == nil , "段错误")
            print("播放Url错误")
            return
        }
        play(url: url)
    }
    ///播放本地视频
    public func play(filePath:String) {
        // 检测连接是否存在 不存在报错
        guard let url = URL(fanFilePath: filePath) else {
            print("播放文件path错误")
            return
        }
        play(url: url)
    }
    ///播放URL
    public func play(url:URL?) {
        // 检测连接是否存在 不存在报错
        guard let url = url else {
            return
        }
        removeObserverListen()
        // 将视频资源赋值给视频播放对象
        let playerItem = AVPlayerItem(url: url)
        if (avPlayer != nil){
            self.avPlayer?.replaceCurrentItem(with: playerItem)
        }else{
            self.avPlayer = AVPlayer(playerItem: playerItem)
            if !playAudio {
                // 初始化视频显示layer
                self.playerLayer = AVPlayerLayer(player: avPlayer)
                // 设置显示模式
                self.playerView?.addPlayerLayer(layer: playerLayer)
                self.playerLayer?.videoGravity = videoGravity
            }
        }
        addObserverListen()
        self.avPlayer?.play()
    }
    ///停止
    public func stop() {
        self.avPlayer?.pause()
        self.removeObserverListen()
    }
    ///暂停
    public func pause() {
        self.avPlayer?.pause()
    }
    /// 重新重头播放
    public func rePlay(){
        playState = 0
        let progress = 0.01
        seek(progress: progress)
        self.avPlayer?.play()
    }
    ///设置播放进度
    public func seek(progress:Double){
        guard let duration = avPlayer?.currentItem?.duration.seconds ,duration > 0.0 else {return}
        if duration.isNaN == false {
            avPlayer?.seek(to: CMTime(value: CMTimeValue(duration*progress), timescale: 1), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { finished in
                //修改进度完成
            })
        }
    }
    ///添加监听播放状态，进度
    public func addObserverListen() {
        objc_sync_enter(self)
        if isPlayerObserver == false {
            playState = 0
            // 监听状态改变
            self.avPlayer?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            // 监听缓冲进度改变
            self.avPlayer?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            timeObser = avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: {[weak self] cTime in
                Task{@MainActor in
                    guard let current = self?.avPlayer?.currentItem?.currentTime().seconds ,current > 0.0 else {return}
                    guard let duration = self?.avPlayer?.currentItem?.duration.seconds ,duration > 0.0 else {return}
                    if !current.isNaN && !duration.isNaN {
                        let progress = min(current/duration, 1.0)
                        //print("播放进度===：\(progress)")
                        self?.playChange(progress: progress)
                    }
                }
            })
            isPlayerObserver = true
        }
        objc_sync_exit(self)
    }
    ///播放进度改变
    private func playChange(progress:Double){
        progressBlock?(progress)
        if playState == 0 {
            if progress > 0 {
                playState = 1
            }else {
                avPlayer?.pause()
                avPlayer?.play()
            }
        }else {
            if progress >= 1.0 {
                playState = 2
            }
        }
    }
    ///移除监听播放状态，进度
    public func removeObserverListen(){
        objc_sync_enter(self)
        if isPlayerObserver {
            self.avPlayer?.removeObserver(self, forKeyPath: "status")
            self.avPlayer?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
            if let timeObser = timeObser {
                self.avPlayer?.removeTimeObserver(timeObser)
            }
            timeObser = nil
            isPlayerObserver = false
        }
        objc_sync_exit(self)
    }
    ///监听播放的进度+状态
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        Task{ @MainActor in
            if keyPath == "status" {
                if avPlayer?.status == .readyToPlay {
                    //开始播放
                }else  if avPlayer?.status == .unknown {
                    //播放未知
                }else  if avPlayer?.status == .failed {
                    //播放失败
                }
                //print("播放状态：\(String(describing: avPlayer?.status))")
            }else if keyPath == "loadedTimeRanges" {
                //缓存进度
                guard let timeRange = avPlayer?.currentItem?.loadedTimeRanges.first?.timeRangeValue else {return}
                let loadingTime = timeRange.start.seconds + timeRange.duration.seconds
                guard let duration = avPlayer?.currentItem?.duration.seconds ,duration > 0.0 else {return}
                if duration.isNaN == false {
                    let progress = min(abs(loadingTime/duration),1.0)
                    loadedCacheBlock?(progress)
                    //print("缓存播放进度\(progress)")
                }
            }
        }
    }
    ///截图
    public func screenshot() -> UIImage?{
        return FanPlayer.screenshotPlayer(avPlayer)
    }
    ///截图播放器
    public static func screenshotPlayer(_ avPlayer:AVPlayer?) -> UIImage? {
        guard let player = avPlayer else { return nil }
        guard let asset = player.currentItem?.asset else { return nil }
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = .zero
        generator.requestedTimeToleranceBefore = .zero
        do {
            let currentTime = player.currentTime()
            let imageRef: CGImage? = try generator.copyCGImage(at: currentTime, actualTime: nil)
            guard let imageRef = imageRef else { return nil }
            return UIImage(cgImage: imageRef)
            //block方式截图
//            let value = NSValue(time: currentTime)
//            generator.generateCGImagesAsynchronously(forTimes: [value]) { requestedTime, imageRef, actualTime, Result, error in
//                
//            }
        } catch {
            print("截图AVPlayer错误: \(error)")
            return nil
        }
    }
    deinit {
        print("FanPlayer deinit 释放")
    }
}
