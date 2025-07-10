//
//  FanUIKitTool.swift
//  
//
//  Created by 凡向阳 on 2024/4/2.
//

import UIKit

//MARK: -  关于UIKit的工具方法
/// 关于UIKit的工具方法
@objcMembers public class FanUIKitTool : NSObject {
    //MARK: - UIWindow相关
    
    @available(iOS 13.0, *)
    /// ///获取活跃的windowScene
    /// - Returns: UIWindowScene
    public class func fan_activeWindowScene() -> UIWindowScene? {
        var actWindowScene: UIWindowScene?
        for windowScene in UIApplication.shared.connectedScenes {
            guard let windowScene = windowScene as? UIWindowScene else {
                continue
            }
            if windowScene.activationState == .foregroundActive {
                actWindowScene = windowScene
                break
            }
        }
        if actWindowScene == nil {
            for windowScene in UIApplication.shared.connectedScenes {
                guard let windowScene = windowScene as? UIWindowScene else {
                    continue
                }
                actWindowScene = windowScene
                break
            }
        }
        return actWindowScene
    }
    /// 获取keywindow
    public class func fan_keyWindow() -> UIWindow? {
        var kWindow: UIWindow?
        if #available(iOS 13.0, *) {
            if #available(iOS 15.0, *) {
                kWindow = FanUIKitTool.fan_activeWindowScene()?.keyWindow
            } else {
                kWindow = FanUIKitTool.fan_activeWindowScene()?.windows.first as? UIWindow
            }
        } else {
            kWindow = UIApplication.shared.keyWindow
            if kWindow == nil {
                if UIApplication.shared.windows.count > 0 {
                    kWindow = UIApplication.shared.windows[0]
                }
            }
        }
        if kWindow == nil {
            if UIApplication.shared.delegate?.responds(to: Selector(("window"))) ?? false {
                kWindow = UIApplication.shared.delegate?.window ?? nil
            }
        }
        return kWindow
    }
    /// 适配screen
    public class func fan_mainScreen() -> UIScreen {
        if #available(iOS 13.0, *) {
            if let wScene = FanUIKitTool.fan_activeWindowScene() {
                return wScene.screen
            } else {
                return .main
            }
        } else {
            return .main
        }
    }
    ///屏幕宽
    public static var fan_width : CGFloat {
        get {
            return  FanUIKitTool.fan_mainScreen().bounds.width
        }
    }
    ///屏幕高
    public static var fan_height : CGFloat {
        get {
            return  FanUIKitTool.fan_mainScreen().bounds.height
        }
    }
}
