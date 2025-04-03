//
//  FanSwiftUI.swift
//  
//
//  Created by 向阳凡 on 2023/11/21.
//

import Foundation
import SwiftUI

//MARK: - 通用方法

/// 本地化文本1
@available(iOS 13.0, *)
/// 本地化文本
public func FanUIString(key:String) -> LocalizedStringKey{
    return LocalizedStringKey(key)
}

// MARK: - 字体样式
/// 系统常规字体
@available(iOS 13.0, *)
public func FanSFont(_ size:CGFloat) -> Font {
    return Font.system(size: size)
}
/// 系统中粗体
@available(iOS 13.0, *)
public func FanSFont(medium size:CGFloat) -> Font {
    return Font.system(size: size,weight: .medium)
}
/// 系统粗体
@available(iOS 13.0, *)
public func FanSFont(bold size:CGFloat) -> Font {
    return Font.system(size: size,weight: .bold)
}
/// 系统粗体
@available(iOS 13.0, *)
public func FanSFont(semibold size:CGFloat) -> Font {
    return Font.system(size: size,weight: .semibold)
}

//MARK: - View扩展系统自带的方法例如 Task方法在iOS13-iOS15
#if canImport(_Concurrency)
import _Concurrency

/// 为SwiftUI中iOS13添加支持task的任务执行
@available(iOS 13.0, *)
public extension View {
    /// 取消 @_inheritActorContext  修饰符 在【_ action】之前
    @available(iOS, introduced: 13.0, obsoleted: 15.0)
    func task(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View {
        modifier(_fanTaskModifier(priority: priority, action: action))
    }
    /// value 是监听值的变化
    @available(iOS, introduced: 14.0, obsoleted: 15.0)
    func task<T>(id value: T, priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View where T: Equatable {
        modifier(_fanTaskValueModifier(value: value, priority: priority, action: action))
    }
}

@available(iOS 13,*)
private struct _fanTaskModifier: ViewModifier {
    @State private var currentTask: Task<Void, Never>?
    let priority: TaskPriority
    let action: @Sendable () async -> Void

    @inlinable public init(priority: TaskPriority, action: @escaping @Sendable () async -> Void) {
        self.priority = priority
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                currentTask = Task(priority: priority, operation: action)
            }
            .onDisappear {
                currentTask?.cancel()
            }
    }
}

@available(iOS 14,*)
private struct _fanTaskValueModifier<Value>: ViewModifier where Value: Equatable {
    var action: @Sendable () async -> Void
    var priority: TaskPriority
    var value: Value
    @State private var currentTask: Task<Void, Never>?
    
    public init(value: Value, priority: TaskPriority, action: @escaping @Sendable () async -> Void) {
        self.action = action
        self.priority = priority
        self.value = value
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                currentTask = Task(priority: priority, operation: action)
            }
            .onDisappear {
                currentTask?.cancel()
            }
            .onChange(of: value) { _ in
                currentTask?.cancel()
                currentTask = Task(priority: priority, operation: action)
            }
    }
}
#endif
//MARK: - View扩展一些常用的方法
@available(iOS 13.0, *)
public extension View {
    ///设置字体颜色
    func fan_textColor(_ color:Color) -> some View {
        modifier(FanTextColorModifier(color))
    }
    ///设置覆盖层
    func fan_overlay<V>(alignment: Alignment = .center, content: () -> V) -> some View where V : View{
        if #available(iOS 15.0, *) {
            return self.overlay(alignment: alignment,content: content)
        } else {
            return self.overlay(content(), alignment: alignment)
        }
    }
}
//MARK: - UI风格 ViewModifier
@available(iOS 13.0.0, *)
/// Button背景图片设置 注意图片要9宫格拉伸
public struct FanImageBgModifier : ViewModifier {
    var imageName : String
    var padding : EdgeInsets
    
    /// 初始化按钮背景
    /// - Parameters:
    ///   - imageName: 背景图片
    ///   - padding: 内边距 默认空
    public init(imageName: String, padding: EdgeInsets = .init()) {
        self.imageName = imageName
        self.padding = padding
    }
    public func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            return content
                .padding(padding)
                .background(alignment: .center, content: {
                    Image(imageName)
                })
        } else {
            return content.padding(padding)
                .background(
                    Image(imageName)
                )
        }
    }
}

@available(iOS 13.0, *)
/// 添加文本颜色
public struct FanTextColorModifier : ViewModifier {
    var color : Color
    
    public init(_ color: Color) {
        self.color = color
    }
    public func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            return content.foregroundStyle(color)
        } else {
            return content.foregroundColor(color)
        }
    }
}
//MARK: - UI风格 其他协议实现
@available(iOS 13.0, *)
/// 自定义圆角 iOS16+可以用UnevenRoundedRectangle
public struct FanRoundedCorner: Shape {
    var topLeading: CGFloat
    var bottomLeading: CGFloat
    var bottomTrailing: CGFloat
    var topTrailing: CGFloat
    public init(topLeading: CGFloat = 0, bottomLeading: CGFloat = 0, bottomTrailing: CGFloat = 0, topTrailing: CGFloat = 0) {
        self.topLeading = topLeading
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
        self.topTrailing = topTrailing
    }
    public func path(in rect: CGRect) -> Path {
        if #available(iOS 16.0, *) {
            return Path(roundedRect: rect, cornerRadii: .init(topLeading: topLeading,bottomLeading: bottomLeading, bottomTrailing: bottomTrailing, topTrailing: topTrailing))
        } else {
            //避免使用UIKit里面的UIBezierPath
            let w = rect.size.width
            let h = rect.size.height
            let tr = min(min(self.topTrailing, h/2), w/2)
            let tl = min(min(self.topLeading, h/2), w/2)
            let bl = min(min(self.bottomLeading, h/2), w/2)
            let br = min(min(self.bottomTrailing, h/2), w/2)
            var path = Path()
            path.move(to: CGPoint(x: w / 2.0, y: 0))
            path.addLine(to: CGPoint(x: w - tr, y: 0))
            path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            path.addLine(to: CGPoint(x: w, y: h - br))
            path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addLine(to: CGPoint(x: bl, y: h))
            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            return path
        }
    }
}
