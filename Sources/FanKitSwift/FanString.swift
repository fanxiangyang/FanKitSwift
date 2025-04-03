//
//  FanString.swift
//  
//
//  Created by 向阳凡 on 2023/11/21.
//

import Foundation
import CryptoKit

//MARK: - String字符串扩展

public extension String {
    
    /// 获取随机字符串(a-zA-Z0-9)
    init (randomLen:Int) {
        let randomStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
        var result:String = ""
        for _ in 0..<randomLen {
            let index = randomStr.index(randomStr.startIndex, offsetBy: Int(arc4random_uniform(UInt32(randomStr.count-1))))
            let uchar:Character = randomStr[index]
            result.append(uchar)
        }
        self.init(result)
    }
    
    /// 获取字符串区间(单字节) startIndex..<endIndex
    func fan_subString(_ startIndex:Int,_ endIndex:Int) -> String {
        if self.count < endIndex {
            return ""
        }
        let index1 = self.index(self.startIndex, offsetBy: startIndex)
        let index2 = self.index(self.startIndex, offsetBy: endIndex)
        let indexRange = index1..<index2
        let subString  = self[indexRange]
        return String(subString)
    }
    //MARK: - String字符串路径名
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
    /// 获取文件路径，无视无后缀名的文件
    var fan_deleteLastPathComponent: String {
        guard let url = URL(string: self) else { return "" }
        return url.deletingLastPathComponent().fan_path
    }
   
    //MARK: - 16进制字符串
    
    /// 16进制字符串转Data
    var fan_hexData:Data {
        var data = Data(capacity: count / 2)
        let regex = try? NSRegularExpression(pattern: "[0-9a-fA-F]{1,2}",options: .caseInsensitive)

        regex?.enumerateMatches(in: self, range: NSRange(startIndex..., in: self), using: { match, _, _ in
            guard let range = Range(match?.range ?? NSRange()) else{
               return
            }
            let byteStr = self.fan_subString(range.startIndex, range.endIndex)
            let num = UInt8(byteStr,radix: 16) ?? 0
            data.append(num)
        })
        return data
    }
    /// 单个16进制字符串转 Int32（字符长度不能超过8个）
    var fan_hexToInt:Int32{
        let num = Int32(self,radix: 16) ?? 0
        return num
    }
    /// 16进制字符串转Asc码字符串(必须是asc码范围的字符串)
    var fan_hexToAscString:String{
        let data = self.fan_hexData
        //注意字符串不要包含00
        let str = String(data: data, encoding: .ascii)
        return str?.utf8.map {
            String(format: "%c" , $0)
        }.joined(separator: "") ?? ""
    }
    
}
// MARK: - 字符串加密
public extension String {
    ///获取字符串Md5
    var fan_md5:String{
        guard let data = data(using: .utf8) else{
            return ""
        }
        return data.fan_md5
    }
    ///获取字符串sha256
    var fan_sha256:String{
        guard let data = data(using: .utf8) else{
            return ""
        }
        return data.fan_sha256
    }
    var fan_base64Encode:String{
        guard let data = data(using: .utf8) else{
            return ""
        }
        return data.base64EncodedString()
    }
    var fan_base64Decode:String{
        guard let data = Data(base64Encoded: self) else{
            return ""
        }
        return .init(data: data, encoding: .utf8) ?? ""
    }
    // AES 加密
    @available(iOS 13.0, *)
    func fan_aesEncrypt(_ key: String) -> String {
        guard let keyData = key.data(using: .utf8) else {
            return ""
        }
        guard let data = Data(base64Encoded: self) else{
            return ""
        }
        // 使用 SHA256 哈希将任意长度密钥转换为 256 位（32字节）密钥
        let hashedKey = SHA256.hash(data: keyData)
        let symmetricKey = SymmetricKey(data: hashedKey)
        guard let sealedBox = try? AES.GCM.seal(data, using: symmetricKey) else{
            return ""
        }
        guard let miStr = sealedBox.combined?.base64EncodedString() else{
            return ""
        }
        return miStr
    }

    // AES 解密
    @available(iOS 13.0, *)
    func fan_aesDecrypt(_ key: String) -> String {
        guard let keyData = key.data(using: .utf8) else {
            return ""
        }
        guard let data = Data(base64Encoded: self),
              let sealedBox = try? AES.GCM.SealedBox(combined: data) else {
            return ""
        }
        // 使用 SHA256 哈希将任意长度密钥转换为 256 位（32字节）密钥
        let hashedKey = SHA256.hash(data: keyData)
        let symmetricKey = SymmetricKey(data: hashedKey)
        guard let decryptedData = try? AES.GCM.open(sealedBox, using: symmetricKey),let deStr = String(data: decryptedData, encoding: .utf8) else {
            return ""
        }
        return deStr
    }
}

//MARK: - URL扩展
public extension URL {
    
    ///创建文件Path
    init?(fanFilePath: String){
        if #available(iOS 16.0, *) {
            self.init(filePath: fanFilePath)
        } else {
            self.init(fileURLWithPath: fanFilePath)
        }
    }
    
    ///默认百分号编码的去掉【 file://User 】
    var fan_path:String{
        if #available(iOS 16.0, *) {
            return self.path()
        } else {
            return self.path
        }
    }
    
}
