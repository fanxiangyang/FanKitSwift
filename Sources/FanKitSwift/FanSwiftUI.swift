//
//  File.swift
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
