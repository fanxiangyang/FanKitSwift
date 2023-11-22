//
//  File.swift
//  
//
//  Created by 向阳凡 on 2023/11/22.
//

import Foundation
import UIKit

//MARK: - UIView相关扩展

public extension UIView {
    
    ///给View 添加Tap手势
    func fan_addTapGesture(target:Any?,action:Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
}

public extension UIViewController {
    
    func fan_statusbarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return FanUIKit.fan_activeWindowScene()?.statusBarManager?.statusBarFrame.size.height ?? 20.0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    func fan_navigationHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            return (FanUIKit.fan_activeWindowScene()?.statusBarManager?.statusBarFrame.size.height ?? 20.0) + (navigationController?.navigationBar.frame.size.height ?? 44.0)
        } else {
            return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.size.height ?? 44.0)
        }
    }
    
    func fan_tabBarHeight() -> CGFloat {
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
