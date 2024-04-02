//
//  File.swift
//  
//
//  Created by 向阳凡 on 2023/11/22.
//

import Foundation
import CommonCrypto


//MARK: - NSDictionary处理
/// NSDictionary读取扩展
@objc public extension NSDictionary{
    ///字典转bool
    func fan_bool(_ forkey:Any) -> Bool {
        let rs = self.object(forKey: forkey)
        if rs is NSNumber {
            return (rs as! NSNumber).boolValue
        }else if rs is NSString {
            return (rs as! NSString) == "1"
        }
        return false
    }
    ///字典转Int  同等 Int32
    func fan_int(_ forkey:Any) -> Int {
        let rs = self.object(forKey: forkey)
        if rs is NSNumber {
            return (rs as! NSNumber).intValue
        }else if rs is NSString {
            return (rs as! NSString).integerValue
        }
        return 0
    }
    ///字典转Int64
    func fan_long(_ forkey:Any) -> Int64 {
        let rs = self.object(forKey: forkey)
        if rs is NSNumber {
            return (rs as! NSNumber).int64Value
        }else if rs is NSString {
            return (rs as! NSString).longLongValue
        }
        return 0
    }
    ///字典转Float
    func fan_float(_ forkey:Any) -> Float {
        let rs = self.object(forKey: forkey)
        if rs is NSNumber {
            return (rs as! NSNumber).floatValue
        }else if rs is NSString {
            return (rs as! NSString).floatValue
        }
        return 0.0
    }
    ///字典转Float
    func fan_double(_ forkey:Any) -> Double {
        let rs = self.object(forKey: forkey)
        if rs is NSNumber {
            return (rs as! NSNumber).doubleValue
        }else if rs is NSString {
            return (rs as! NSString).doubleValue
        }
        return 0.0
    }
    ///字典转String
    func fan_string(_ forkey:Any) -> String {
        let rs = self.object(forKey: forkey)
        return (rs as? String) ?? ""
    }
    ///字典转NSString
    func fan_nsstring(_ forkey:Any) -> NSString {
        let rs = self.object(forKey: forkey)
        return (rs as? NSString) ?? ""
    }
    ///字典转NSArray
    func fan_nsarray(_ forkey:Any) -> NSArray {
        let rs = self.object(forKey: forkey)
        return (rs as? NSArray) ?? NSArray()
    }
    ///字典转NSArray
    func fan_array(_ forkey:Any) -> [Any] {
        let rs = self.object(forKey: forkey)
        return (rs as? [Any]) ?? []
    }
    ///字典转NSDictionary
    func fan_nsdictionary(_ forkey:Any) -> NSDictionary {
        let rs = self.object(forKey: forkey)
        return (rs as? NSDictionary) ?? NSDictionary()
    }
    ///字典转NSArray
    func fan_dictionary(_ forkey:Any) -> [String : Any] {
        let rs = self.object(forKey: forkey)
        return (rs as? [String:Any]) ?? [:]
    }
}

//MARK: - Data扩展
/// Data 关于字节数据处理
public extension Data{
    
    ///小端第1个4字节参数
    var fan_p1:UInt32 {
        if(self.count<4){
            return 0
        }
        var result : UInt32 = 0
        let pData = self.subdata(in: 0..<4)
//        result = UInt32(littleEndian: pData.withUnsafeBytes({ d in
//            d.load(as: UInt32.self)
//        }))
        //data转
        result = UInt32(littleEndian: pData.withUnsafeBytes({
            $0.load(as: UInt32.self)
        }))
        //NSData方法
        //(pData as NSData).getBytes(&result, length: MemoryLayout<UInt32>.size)
        return result
    }
    ///小端第2个4字节参数
    var fan_p2 : UInt32 {
        if(self.count<8){
            return 0
        }
        var result : UInt32 = 0
        let pData = self.subdata(in: 4..<8)
        //data转
        result = UInt32(littleEndian: pData.withUnsafeBytes({
            $0.load(as: UInt32.self)
        }))
        return result
    }
    ///小端第3个4字节参数
    var fan_p3 : UInt32 {
        if(self.count<12){
            return 0
        }
        var result : UInt32 = 0
        let pData = self.subdata(in: 8..<12)
        //data转
        result = UInt32(littleEndian: pData.withUnsafeBytes({
            $0.load(as: UInt32.self)
        }))
        return result
    }
    
    /// 得到任何位置4字节小短参数UInt32
    /// - Parameters:
    ///   - loc: 起始位置
    ///   - length: 长度
    /// - Returns: 结果
    func fan_any_p(_ loc:UInt32,_ length:UInt32) -> UInt32 {
        if(self.count<(loc+length)){
            return 0
        }
        var result : UInt32 = 0
        let pData = self.subdata(in: Int(loc)..<Int(loc+length))
        //data转
        result = UInt32(littleEndian: pData.withUnsafeBytes({
            $0.load(as: UInt32.self)
        }))
        return result
    }
    //MARK: - Data  socket字节编码
    ///判断系统是大端还是小端-目前苹果生态都是小端
    static func fan_isLittleEndian() -> Bool {
        var i:Int32 = 1
        let data = Data(bytes: &i, count: 4)
        return data[0] == 1
    }
    /// Int8-Data
    static func fan_packInt8(_ val:Int8) -> Data {
        let size = MemoryLayout<Int8>.size
        var value = val
        return Data(bytes: &value, count: size)
    }
    /// Int16-Data
    static func fan_packInt16(_ val:Int16,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Int16>.size
        var value = val
        if bigEndian {
            value = value.byteSwapped
        }
        return Data(bytes: &value, count: size)
    }
    /// Int-Data
    static func fan_packInt(_ val:Int,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Int>.size
        var value = val
        if bigEndian {
            value = value.byteSwapped
        }
        return Data(bytes: &value, count: size)
    }
    /// Int32-Data
    static func fan_packInt32(_ val:Int32,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Int32>.size
        var value = val
        if bigEndian {
            value = value.byteSwapped
        }
        return Data(bytes: &value, count: size)
    }
    /// Int64-Data
    static func fan_packInt64(_ val:Int64,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Int64>.size
        var value = val
        if bigEndian {
            value = value.byteSwapped
        }
        return Data(bytes: &value, count: size)
    }
    /// Float-Data
    static func fan_packFloat(_ val:Float,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Float>.size
        var value = val
        var data = Data(bytes: &value, count: size)
        if bigEndian {
            data = data.fan_des
        }
        return data
    }
    /// Float32-Data
    static func fan_packFloat32(_ val:Float32,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Float32>.size
        var value = val
        var data = Data(bytes: &value, count: size)
        if bigEndian {
            //把四字节转成Int32处理
            var bd = data.withUnsafeBytes { d in
                d.load(as: Int32.self).byteSwapped
            }
            //两个方法都可以
//            var bd = Int32(bigEndian: data.withUnsafeBytes({ d in
//                d.load(as: Int32.self)
//            }))
            data = Data(bytes: &bd, count: size)
        }
        return data
    }
    /// Double-Data
    static func fan_packDouble(_ val:Double,bigEndian:Bool = false) -> Data {
        let size = MemoryLayout<Double>.size
        var value = val
        var data = Data(bytes: &value, count: size)
        if bigEndian {
            data = data.fan_des
        }
        return data
    }
    /// Data-Int8
    var fan_unpackInt8: Int8 {
        let result = Int8(littleEndian: self.withUnsafeBytes({
            $0.load(as: Int8.self)
        }))
        return result
    }
    /// Data-Int16
    func fan_unpackInt16(bigEndian:Bool = false) -> Int16 {
        var result = self.withUnsafeBytes {
            $0.load(as: Int16.self)
        }
        if bigEndian {
            result = Int16(bigEndian: result)
        }
        return result
    }
    /// Data-Int
    func fan_unpackInt(bigEndian:Bool = false) -> Int {
        var result = self.withUnsafeBytes {
            $0.load(as: Int.self)
        }
        if bigEndian {
            result = Int(bigEndian: result)
        }
        return result
    }
    /// Data-Int32
    func fan_unpackInt32(bigEndian:Bool = false) -> Int32 {
        var result = self.withUnsafeBytes {
            $0.load(as: Int32.self)
        }
        if bigEndian {
            result = Int32(bigEndian: result)
        }
        return result
    }
    /// Data-Int64
    func fan_unpackInt64(bigEndian:Bool = false) -> Int64 {
        var result = self.withUnsafeBytes {
            $0.load(as: Int64.self)
        }
        if bigEndian {
            result = Int64(bigEndian: result)
        }
        return result
    }
    /// Data-Float
    func fan_unpackFloat(bigEndian:Bool = false) -> Float {
        var result:Float = 0
        if bigEndian {
            result = self.fan_des.withUnsafeBytes {
                $0.load(as: Float.self)
            }
        }else {
            result = self.withUnsafeBytes {
                $0.load(as: Float.self)
            }
        }
        return result
    }
    /// Data-Float32
    func fan_unpackFloat32(bigEndian:Bool = false) -> Float32 {
        var result:Float32 = 0
        if bigEndian {
            result = self.fan_des.withUnsafeBytes {
                $0.load(as: Float32.self)
            }
        }else {
            result = self.withUnsafeBytes {
                $0.load(as: Float32.self)
            }
        }
        return result
    }
    /// Data-Float
    func fan_unpackDouble(bigEndian:Bool = false) -> Double {
        var result:Double = 0
        if bigEndian {
            result = self.fan_des.withUnsafeBytes {
                $0.load(as: Double.self)
            }
        }else {
            result = self.withUnsafeBytes {
                $0.load(as: Double.self)
            }
        }
        return result
    }
    /// Data倒序字节排序
    var fan_des:Data{
        var i = self.count
        var arr:[UInt8] = []
        while i > 0 {
            i = i - 1
            arr.append(self[i])
        }
        let data = Data(bytes: arr, count: self.count)
        return data
    }
    //MARK: - Data转16进制字符串
    /// Data转16进制字符串
    var fan_hexString:String {
        //方法一
//        var str:String = ""
//        for b in self {
//            str = str + String(format: "%02X" , b)
//        }
//        return str
        //方法二
        return map {
            String(format: "%02X" , $0)
        }.joined(separator: "")
    }
    ///获取字符串Md5
    var fan_md5:String{
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = self.withUnsafeBytes { bytes in
            return CC_MD5(bytes.baseAddress,CC_LONG(self.count),&digest)
        }
        return digest.map {
            String(format:"%02x",$0)
        }.joined()
    }

}
/// 整型数据转Data
public extension ExpressibleByIntegerLiteral {
    /// 直接获取数据Data
    var fan_data: Data {
        fan_toData(value: self)
    }
}
public extension Data {
    var fan_int32: Int32 {
        fan_toIntValue(data: self)
    }
    
    var fan_uint32: UInt32 {
        fan_toIntValue(data: self)
    }
    
    var fan_int16: Int16 {
        fan_toIntValue(data: self)
    }
    
    var fan_uint16: UInt16 {
        fan_toIntValue(data: self)
    }
    
    var fan_int8: Int8 {
        fan_toIntValue(data: self)
    }
    
    var fan_uint8: UInt8 {
        fan_toIntValue(data: self)
    }
}
