//
//  FanViewExtension.swift
//
//
//  Created by 向阳凡 on 2023/11/22.
//

import Foundation
import UIKit

//MARK: - UIView相关扩展

@objc public extension UIView {
    //MARK: - 手势相关
    ///给View 添加Tap手势
    func fan_addTapGesture(target:Any?,action:Selector?) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    ///给View 添加LongPress手势
    func fan_addLongPressGesture(target:Any?,action:Selector?) {
        let gesture = UILongPressGestureRecognizer(target: target, action: action)
//        gesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(gesture)
    }
    //MARK: - 圆角边框
    ///裁剪layer圆角
    func fan_addClip(_ radius:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    ///添加边框颜色和宽度
    func fan_addBorder(color:UIColor,width:CGFloat = 1){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    //MARK: - 控件拉伸，压缩
    ///抗拉伸优先级 默认250 低的会优先拉伸  横向竖向
    func fan_hugging(_ priority:UILayoutPriority){
        self.setContentHuggingPriority(priority, for: .horizontal)
        self.setContentHuggingPriority(priority, for: .vertical)
    }
    ///抗压缩优先级 默认750 低的会优先压缩  横向竖向
    func fan_compressionResistance(_ priority:UILayoutPriority){
        self.setContentCompressionResistancePriority(priority, for: .horizontal)
        self.setContentCompressionResistancePriority(priority, for: .vertical)
    }
}

@objc public extension UIStackView {
    ///创建StackView 默认垂直居中填充
    class func fan_stackView(spacing:CGFloat,axis:NSLayoutConstraint.Axis = .vertical) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
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
///UIButton按钮 图文位置类型
@objc public enum FanImagePlacement:UInt {
//    case none = 0
    case top = 1
    case left = 2
    case bottom = 4
    case right = 8
}

@objc public extension UIButton {
    ///创建只有文本的按钮+内间距 （文本只支持单行和多行，不支持固定2行）
    class func fan_btn(title:String?,textColor:UIColor,font:UIFont,edge:UIEdgeInsets = .zero) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = font
        btn.setTitleColor(textColor, for: .normal)
        if #available(iOS 15.0, *) {
            var config = Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: edge.top, leading: edge.left, bottom: edge.bottom, trailing: edge.right)
            config.imagePadding = 0
            config.titleTextAttributesTransformer =  .init({ container in
                var newContainer = container
                newContainer.foregroundColor = textColor
                newContainer.font = font
                return newContainer
            })
//            config.buttonSize = .large
//            config.titleLineBreakMode = .byCharWrapping
//            config.imagePlacement = .leading
            btn.configuration = config
        } else {
            btn.contentEdgeInsets = edge
        }
        return btn
    }
    /// 创建只有图片的按钮+内间距
    class func fan_btn(imageName:String,edge:UIEdgeInsets = .zero) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: imageName), for: .normal)
        if #available(iOS 15.0, *) {
            var config = Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: edge.top, leading: edge.left, bottom: edge.bottom, trailing: edge.right)
            btn.configuration = config
        } else {
            btn.contentEdgeInsets = edge
        }
        return btn
    }
    @discardableResult
    /// 添加字体颜色+大小
    func fan_add(textColor:UIColor,font:UIFont) -> Self{
        if #available(iOS 15.0, *) {
            var config = self.configuration
            if config != nil {
                config?.titleTextAttributesTransformer =  .init({ container in
                    var newContainer = container
                    newContainer.foregroundColor = textColor
                    newContainer.font = font
                    return newContainer
                })
                self.configuration = config
                return self
            }
        }
        self.titleLabel?.font = font
        self.setTitleColor(textColor, for: .normal)
        return self
    }
    @discardableResult
    /// 添加内容内间距
    func fan_add(edge:UIEdgeInsets) -> Self{
        if #available(iOS 15.0, *) {
            var config = self.configuration
            if config != nil {
                config?.contentInsets = NSDirectionalEdgeInsets(top: edge.top, leading: edge.left, bottom: edge.bottom, trailing: edge.right)

                self.configuration = config
                return self
            }
        }
        self.contentEdgeInsets = edge
        return self
    }
    @discardableResult
    /// 添加图片内容内间距,+图片与text间距
    func fan_add(imagePadding:CGFloat,postion:FanImagePlacement = .left) -> Self{
        if #available(iOS 15.0, *) {
            var config = self.configuration
            if config != nil {
                config?.imagePadding = imagePadding
                switch postion {
                case .left:
                    config?.imagePlacement = .leading
                case .right:
                    config?.imagePlacement = .trailing
                case .top:
                    config?.imagePlacement = .top
                case .bottom:
                    config?.imagePlacement = .bottom
                default:
                    config?.imagePlacement = .leading
                }
                self.configuration = config
                return self
            }
        }
        var contentInsets = self.contentEdgeInsets
        var imageInsets = self.imageEdgeInsets
        switch postion {
        case .left:
            contentInsets.left += imagePadding;
            imageInsets.left -= imagePadding;
            imageInsets.right += imagePadding;
        case .right:
            contentInsets.right += imagePadding;
            imageInsets.left += imagePadding;
            imageInsets.right -= imagePadding;
        case .top:
            contentInsets.top += imagePadding;
            imageInsets.top -= imagePadding;
            imageInsets.bottom += imagePadding;
        case .bottom:
            contentInsets.bottom += imagePadding;
            imageInsets.top += imagePadding;
            imageInsets.bottom -= imagePadding;
        }
        self.contentEdgeInsets = contentInsets
        self.imageEdgeInsets = imageInsets
        return self
    }
}
