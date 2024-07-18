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


//MARK: - View扩展Task方法在iOS13-iOS15
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
    ///设置字体颜色
    func fan_textColor(_ color:Color) -> some View {
        modifier(FanTextColorModifier(color))
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


//MARK: - UI风格
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

