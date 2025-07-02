//
//  FanSwiftExtension.swift
//  FanKitSwift
//
//  Created by 凡向阳 on 2025/6/27.
//

/// 字典取内容快捷方法-默认值
public extension Dictionary where Key == String {
    /// 获取默认类型值
    /// - Parameters:
    ///   - key: key
    ///   - def: 默认值
    /// - Returns: 特定对象
    func fan_value<T>(_ key: String, def: T) -> T {
        return self[key] as? T ?? def
    }
    ///获取Int8
    func fan_int8(_ key: String) -> Int8 {
        return self[key] as? Int8 ?? 0
    }
    ///获取UInt8
    func fan_uint8(_ key: String) -> UInt8 {
        return self[key] as? UInt8 ?? 0
    }
    ///获取Int
    func fan_int(_ key: String) -> Int {
        return self[key] as? Int ?? 0
    }
    ///获取Int
    func fan_int16(_ key: String) -> Int16 {
        return self[key] as? Int16 ?? 0
    }
    ///获取Int32
    func fan_int32(_ key: String) -> Int32 {
        return self[key] as? Int32 ?? 0
    }
    ///获取Float
    func fan_float(_ key: String) -> Float {
        return self[key] as? Float ?? 0.0
    }
    ///获取Double
    func fan_double(_ key: String) -> Double {
        return self[key] as? Double ?? 0.0
    }
    ///获取Bool
    func fan_bool(_ key: String) -> Bool {
        return self[key] as? Bool ?? false
    }
    ///获取String
    func fan_string(_ key: String) -> String {
        return self[key] as? String ?? ""
    }
    ///获取[String:Any]
    func fan_dic(_ key: String) -> [String:Any] {
        return self[key] as? [String:Any] ?? [:]
    }
    ///获取[Any]
    func fan_arr(_ key: String) -> [Any] {
        return self[key] as? [Any] ?? []
    }
}
