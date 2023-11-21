//
//  File.swift
//  
//
//  Created by 向阳凡 on 2023/11/21.
//

import Foundation

public extension String {
    /// 获取字符串区间
    func fan_subString(_ startIndex:Int,_ endIndex:Int) -> String {
        if self.lengthOfBytes(using: .utf8) <= endIndex {
            return ""
        }
        let index1 = self.index(self.startIndex, offsetBy: startIndex)
        let index2 = self.index(self.startIndex, offsetBy: endIndex)
        let indexRange = index1...index2
        let subString  = self[indexRange]
        return String(subString)
    }
    
    /// 获取文件全名
    var fan_lastPathComponent: String {
        guard let url = URL(string: self) else { return "" }
        return url.lastPathComponent
    }
    /// 获取文件后缀
    var fan_pathExtension: String {
        guard let url = URL(string: self) else { return "" }
        return url.pathExtension
    }
    /// 获取文件名不包含后缀
    var fan_fileName: String {
        let name = self.fan_lastPathComponent
        let arr = name.components(separatedBy: ".")
        return arr.first ?? ""
    }
}
