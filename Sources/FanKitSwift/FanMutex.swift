//
//  FanMutex.swift
//  FanKitSwift
//
//  Created by 凡向阳 on 2025/8/5.
//


import Foundation
import os.lock

/// 一个线程安全的泛型互斥锁（仿 Swift 6 Mutex）
/// iOS 13+ 可用
final public class FanMutex<T> {
    private var _value: T
    private var lock = os_unfair_lock_s()

    public init(_ value: T) {
        _value = value
    }

    /// 同步访问包装的值（可修改）
    @discardableResult
    public func withLock<R>(_ body: (inout T) throws -> R) rethrows -> R {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try body(&_value)
    }

    /// 同步读取包装的值（不可修改）
    @discardableResult
    public func withLockValue<R>(_ body: (T) throws -> R) rethrows -> R {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try body(_value)
    }
}

/// 用锁的原子类，支持泛型，iOS18Atomic仅支持值类型
final public class FanAtomic<Value> {
    private var _value: Value
    private var lock = os_unfair_lock_s()
    
    public init(_ value: Value) {
        _value = value
    }
    
    public func load() -> Value {
        os_unfair_lock_lock(&lock)
        let value = _value
        os_unfair_lock_unlock(&lock)
        return value
    }
    
    public func store(_ newValue: Value) {
        os_unfair_lock_lock(&lock)
        _value = newValue
        os_unfair_lock_unlock(&lock)
    }
    
    @discardableResult
    public func exchange(_ newValue: Value) -> Value {
        os_unfair_lock_lock(&lock)
        let oldValue = _value
        _value = newValue
        os_unfair_lock_unlock(&lock)
        return oldValue
    }
}
///禁止在 withLock{} 内部调用同一个对象的 load/store/exchange/withLock/wrappedValue
public extension FanAtomic {
    @discardableResult
    func withLock<R>(_ body: (inout Value) -> R) -> R {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return body(&_value)
    }
}

final class FanUnfairLockBox {
    var unfairLock = os_unfair_lock_s()
}
/// 定义一个 FanLock 属性包装器 - 用了性能高的os_unfair_lock_lock
@propertyWrapper
public struct FanLock<T> {
    private var value: T
    private var lock = FanUnfairLockBox()

    public init(wrappedValue: T) {
        self.value = wrappedValue
    }

    public var wrappedValue: T {
        get {
            os_unfair_lock_lock(&lock.unfairLock)
            let v = value
            os_unfair_lock_unlock(&lock.unfairLock)
            return v
        }
        set {
            os_unfair_lock_lock(&lock.unfairLock)
            value = newValue
            os_unfair_lock_unlock(&lock.unfairLock)
        }
    }
    ///禁止在 withLock{} 内部调用同一个对象的 withLock/wrappedValue
    public mutating func withLock<R>(_ body: (inout T) -> R) -> R {
        os_unfair_lock_lock(&lock.unfairLock)
        defer { os_unfair_lock_unlock(&lock.unfairLock) }
        return body(&value)
    }
}
///数组添加的语义化方法
public extension FanLock where T: RangeReplaceableCollection {
    mutating func append(_ element: T.Element) {
        os_unfair_lock_lock(&lock.unfairLock)
        defer { os_unfair_lock_unlock(&lock.unfairLock) }
        value.append(element)
    }
}
/// 字典添加的专用扩展
public extension FanLock where T == [String: Int] {
    mutating func increment(key: String) {
        os_unfair_lock_lock(&lock.unfairLock)
        defer { os_unfair_lock_unlock(&lock.unfairLock) }
        value[key, default: 0] += 1
    }
}
