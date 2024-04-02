//
//  File.swift
//  
//
//  Created by 向阳凡 on 2023/11/22.
//

import Foundation
import UIKit

//MARK: - UIView相关扩展

@objc public extension UIView {
    
    ///给View 添加Tap手势
    func fan_addTapGesture(target:Any?,action:Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
}

@objc public extension UIViewController {
    ///状态栏高度
    func fan_statusBarH() -> CGFloat {
        if #available(iOS 13.0, *) {
            return FanUIKitTool.fan_activeWindowScene()?.statusBarManager?.statusBarFrame.size.height ?? 20.0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    /// 导航栏高度
    func fan_navHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return (FanUIKitTool.fan_activeWindowScene()?.statusBarManager?.statusBarFrame.size.height ?? 20.0) + (navigationController?.navigationBar.frame.size.height ?? 44.0)
        } else {
            return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.size.height ?? 44.0)
        }
    }
    /// tabBar高度
    func fan_tabBarH() -> CGFloat {
        return tabBarController?.tabBar.frame.size.height ?? 49.0
    }
    
    ///添加子VC-并且添加view
    func fan_addChild(_ vc: UIViewController?) {
        if let vc {
            addChild(vc)
            view.addSubview(vc.view)
        }
    }
    
    ///从父控制器移除-并且移除view
    func fan_removeFromParent() {
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
