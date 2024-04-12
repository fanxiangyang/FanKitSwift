//
//  FanDateExtension.swift
//
//
//  Created by 凡向阳 on 2024/4/8.
//

import Foundation

public extension Date {
    ///日期字符串转换成Date（yyyy-MM-dd HH:mm:ss）
    static func fan_date(from dateStr:String,format:String,timeZone:TimeZone = TimeZone.current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.date(from: dateStr)
    }
    ///日期转换成需要的格式（yyyy-MM-dd HH:mm:ss）
    func fan_string(format:String = "yyyy-MM-dd HH:mm:ss",timeZone:TimeZone = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    /// 获取日历年月日时分秒格式
    func fan_dateComponents(timeZone:TimeZone = TimeZone.current) -> DateComponents{
        var components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: self)
        components.timeZone = timeZone
        return components
    }
    /// 获取年
    var fan_year:Int {
        return Calendar.current.component(.year, from: self)
    }
    /// 获取月
    var fan_month:Int {
        return Calendar.current.component(.month, from: self)
    }
    /// 获取日
    var fan_day:Int {
        return Calendar.current.component(.day, from: self)
    }
    /// 获取时
    var fan_hour:Int {
        return Calendar.current.component(.hour, from: self)
    }
    /// 获取分
    var fan_minute:Int {
        return Calendar.current.component(.minute, from: self)
    }
    /// 获取秒
    var fan_second:Int {
        return Calendar.current.component(.second, from: self)
    }
}
