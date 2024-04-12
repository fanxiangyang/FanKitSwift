//
//  FanTool.swift
//  
//
//  Created by 向阳凡 on 2023/11/22.
//

import Foundation

/// 本机IP地址类型
public enum FanIPType : String {
    case wifiIpv4 = "en0/ipv4"
    case wifiIpv6 = "en0/ipv6"
    case cellularIpv4 = "pdp_ip0/ipv4"
    case cellularIpv6 = "pdp_ip0/ipv6"
    case vpnIpv4 = "utun0/ipv4"
    case vpnIpv6 = "utun0/ipv6"
}
/// 工具方法
@objcMembers public class FanTool: NSObject {
    //MARK: - Json字符串处理
    /// JSON字符串转字典
    public static func fan_dic(_ jsonStr:String?)->[String : Any]?{
        let data = jsonStr?.data(using: .utf8)
        return fan_dic(jsonData: data)
    }
    /// json文件路径转字典
    public static func fan_dic(jsonPath:String?)->[String : Any]?{
        guard let jsonPath = jsonPath else{
            return nil
        }
        if FileManager.default.fileExists(atPath: jsonPath) {
            let url = URL(fanFilePath: jsonPath)
            if let url = url {
                let data = try? Data(contentsOf:url)
                return fan_dic(jsonData: data)
            }
        }
        return nil
    }
    /// jsonData转字典
    public static func fan_dic(jsonData:Data?)->[String : Any]?{
        guard let data = jsonData else{
            return nil
        }
        //.fragmentsAllowed 指定解析的时候允许最外层(最顶层)的对象可以不是一个数组或字典对象
        //.mutableLeaves 指定返回json对象内部的字符串为可变字符串的实例
        //.mutableContainers 可变的数组和字典
        let jsonObject = try? JSONSerialization.jsonObject(with: data,options: [])
        if let dic = jsonObject as? [String:Any] {
            return dic
        }
        return nil
    }
    /// JSON字符串转字典
    public static func fan_array(_ jsonStr:String?)->[Any]?{
        let data = jsonStr?.data(using: .utf8)
        return fan_array(jsonData: data)
    }
    /// json文件路径转字典
    public static func fan_array(jsonPath:String?)->[Any]?{
        guard let jsonPath = jsonPath else{
            return nil
        }
        if FileManager.default.fileExists(atPath: jsonPath) {
            let url = URL(fanFilePath: jsonPath)
            if let url = url {
                let data = try? Data(contentsOf:url)
                return fan_array(jsonData: data)
            }
        }
        return nil
    }
    /// jsonData转字典
    public static func fan_array(jsonData:Data?)->[Any]?{
        guard let data = jsonData else{
            return nil
        }
        //.fragmentsAllowed 指定解析的时候允许最外层(最顶层)的对象可以不是一个数组或字典对象
        //.mutableLeaves 指定返回json对象内部的字符串为可变字符串的实例
        //.mutableContainers 可变的数组和字典
        let jsonObject = try? JSONSerialization.jsonObject(with: data,options: [])
        if let dic = jsonObject as? [Any] {
            return dic
        }
        return nil
    }
    //MARK: - 文件处理
    /// 获取沙河【Documents】路径
    public static func fan_documentPath()->String{
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        if path.count <= 0 {
            path = NSHomeDirectory().appending("/Documents")
        }
        return path
    }
    /// 获取沙河【Library/Caches】路径
    public static func fan_cachePath()->String{
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if path.count <= 0 {
            path = NSHomeDirectory().appending("/Library/Caches")
        }
        return path
    }
    /// 获取沙河【tmp】路径
    public static func fan_tmpPath()->String{
        //NSTemporaryDirectory()生成的带/private/var---/tmp/
        var path = NSTemporaryDirectory()
        if path.count <= 0 {
            path = NSHomeDirectory().appending("/tmp")
        }
        return path
    }
    /// 是否只存在文件，不是路径
    public static func fan_fileExists(atPath:String)->Bool{
        var isDir:ObjCBool = false
        if FileManager.default.fileExists(atPath: atPath,isDirectory: &isDir) {
            if isDir.boolValue == false {
                return true
            }
        }
        return false
    }
    
    ///自动创建路径-（默认不包括含后缀名的文件名）
    /// - Parameters:
    ///   - atPath: 创建路径
    ///   - deleteLastPath: 是否删除文件名,只保留路径
    /// - Returns: 是否创建成功
    public static func fan_create(atPath:String,deleteLastPath:Bool)->Bool{
        var path = atPath
        var result = false
        let file = FileManager.default
        if file.fileExists(atPath: path) == false {
            if deleteLastPath {
                path = path.fan_deleteLastPathComponent
            }
            do{
                try file.createDirectory(atPath: path, withIntermediateDirectories: true)
                result = true
            }catch {
                result = false
                print("创建路径error:\(error)")
            }
        }
        return result
    }
    ///强制copy文件到目的全路径，旧文件被删除
    public static func fan_copy(atPath:String,toPath:String)->Bool{
        if (atPath ==  toPath){
            return true
        }
        _ = fan_create(atPath: toPath,deleteLastPath: true)
        var result = false
        let file = FileManager.default
        if file.fileExists(atPath: atPath) {
            var isDir:ObjCBool = false
            if file.fileExists(atPath: toPath,isDirectory: &isDir) {
                if isDir.boolValue == false {
                    try? file.removeItem(atPath: toPath)
                    try? file.copyItem(atPath: atPath, toPath: toPath)
                }else{
                    //是路径不处理
                }
            }else{
                try? file.copyItem(atPath: atPath, toPath: toPath)
            }
        }
        var isCopyDir:ObjCBool = false
        if file.fileExists(atPath: atPath,isDirectory: &isCopyDir) {
            if isCopyDir.boolValue == false {
                result = true
            }
        }
        return result
    }
    /// copy文件夹(默认旧文件不移除)
    public static func fan_copy(from sourcePath: String, to destinationPath: String,removeOld:Bool = false) {
        let fileManager = FileManager.default
        // 检查源文件夹是否存在
        if fileManager.fileExists(atPath: sourcePath) {
            // 获取源文件夹中的所有文件和子文件夹
            guard let folderContents = try? fileManager.contentsOfDirectory(atPath: sourcePath) else {
                return
            }
            // 创建目标文件夹（如果不存在）
            _ = fan_create(atPath: destinationPath,deleteLastPath: false)
            
            // 复制文件和子文件夹到目标文件夹
            for item in folderContents {
                let sPath = sourcePath+"/"+item
                let dPath = destinationPath+"/"+item
                
                var isDir:ObjCBool = false
                if fileManager.fileExists(atPath: sPath,isDirectory: &isDir) {
                    if isDir.boolValue == false {
                        //文件，查看是否有目的文件
                        var isDirPath:ObjCBool = false
                        if fileManager.fileExists(atPath: dPath,isDirectory: &isDirPath) {
                            // 文件已经存在,判断是否移除旧文件
                            if isDirPath.boolValue == false {
                                if removeOld {
                                    try? fileManager.removeItem(atPath: dPath)
                                }else{
                                    continue
                                }
                            }
                        }
                        // 如果是文件，直接复制
                        do {
                            try fileManager.copyItem(atPath: sPath, toPath: dPath)
                        } catch {
                            print("无法复制文件：\(item) - \(error)")
                        }
                    }else{
                        // 如果是文件夹，递归复制子文件夹和文件
                        fan_copy(from: sPath, to: dPath,removeOld: removeOld)
                    }
                }else {
                    print("无效的文件或文件夹：\(item)")
                }
            }
        } else {
            print("源文件夹不存在:\(sourcePath)")
        }
    }
    /// 只删除文件，不删除路径
    public static func fan_deleteFile(_ atPath:String) -> Bool {
        var result = false
        var isDir:ObjCBool = false
        if FileManager.default.fileExists(atPath: atPath,isDirectory: &isDir) {
            if isDir.boolValue == false {
                do {
                    try FileManager.default.removeItem(atPath: atPath)
                    result = true
                }catch{
                    print("移除文件error:\(error)")
                }
            }
        }else{
            result = true
        }
        return result
    }
    /// 删除文件/文件夹路径下所有文件
    public static func fan_delete(atPath:String,deleteRootDir:Bool = true) {
        let fileManager = FileManager.default
        var isDir:ObjCBool = false
        if fileManager.fileExists(atPath: atPath,isDirectory: &isDir) {
            if isDir.boolValue == false {
                //文件
                try? FileManager.default.removeItem(atPath: atPath)
            }else{
                let arr:[String] = fileManager.subpaths(atPath: atPath) ?? []
                for fileName in arr {
//                    print("删除文件遍历：\(fileName)")
                    try? fileManager.removeItem(atPath: (atPath.appending("/"+fileName)))
                }
                if deleteRootDir {
                    try? fileManager.removeItem(atPath: atPath)
                }
            }
        }
    }
    /// 移动文件或者文件夹(默认旧文件不移除)
    public static func fan_move(frome sourcePath:String,to dPath:String, removeOld:Bool = false) {
        let fileManager = FileManager.default
        var isDir:ObjCBool = false
        if fileManager.fileExists(atPath: sourcePath,isDirectory: &isDir) {
            if isDir.boolValue {
                //文件夹
                let arr:[String] = fileManager.subpaths(atPath: sourcePath) ?? []
                for fileName in arr {
//                    print("Move文件遍历：\(fileName)")
                    let sPath = sourcePath.appending("/"+fileName)
                    let toPath = dPath.appending("/"+fileName)
                  
                    var isDirPath:ObjCBool = false
                    if fileManager.fileExists(atPath: sPath,isDirectory: &isDirPath) {
                        if isDirPath.boolValue == false {
                            //是文件
                            if removeOld {
                                try? fileManager.removeItem(atPath: toPath)
                            }
                            _ = fan_create(atPath: toPath,deleteLastPath: true)
                            do {
                                try fileManager.moveItem(atPath: (sourcePath.appending("/"+fileName)), toPath:toPath )
                            }catch{
                                print("移动文件error：\(error)")
                            }
                        }else{
                            //文件夹不处理
                        }
                    }else{
                        //不可能有这个情况
                    }
                }
                
            }else{
                //文件
                if fileManager.fileExists(atPath: dPath) {
                    if removeOld {
                        try? fileManager.removeItem(atPath: dPath)
                    }else {
                        return
                    }
                }else{
                    _ = fan_create(atPath: dPath,deleteLastPath: true)
                }
                try? fileManager.moveItem(atPath: sourcePath, toPath: dPath)
            }
        }
    }
    /// 获取文件或文件夹大小
    public static func fan_folderSize(_ atPath: String) -> Int64 {
        let fileManager = FileManager.default
        var totalSize: Int64 = 0
        var isDirectory:ObjCBool = false
        if fileManager.fileExists(atPath: atPath,isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                var options: FileManager.DirectoryEnumerationOptions = [.skipsSubdirectoryDescendants, .skipsHiddenFiles]
                if #available(iOS 10.0, *) {
                    options.insert(.skipsPackageDescendants)
                }
                do {
                    guard let url = URL(fanFilePath: atPath) else { return 0 }
                    let urls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options)
                    for subUrl in urls {
                        let fileSize = try fileManager.attributesOfItem(atPath: subUrl.fan_path)[FileAttributeKey.size]
                        totalSize += (fileSize ?? 0) as! Int64
                    }
                } catch {
                    print("Failed to get folder size: \(error)")
                    return 0
                }
            } else {
                guard let fileAttributes = try? fileManager.attributesOfItem(atPath: atPath) else {
                    return 0
                }
                totalSize = (fileAttributes[FileAttributeKey.size] ?? 0) as! Int64
            }
        }
        return totalSize
    }
    
   


}
//MARK: - 数学公式
/// 数学公式
public extension FanTool {
    
    /// 获取三次Hermite插值函数y
    /// - Parameters:
    ///   - p0: 开始点
    ///   - p1: 结束点
    ///   - rp0: 开始点倒数
    ///   - rp1: 结束点倒数
    ///   - x: 带入x
    /// - Returns: y
    static func fan_hemite(p0:CGPoint,p1:CGPoint,rp0:Double,rp1:Double,x:Double)->Double{
        if p1.x - p0.x == 0.0 {
            return 0.0
        }
        return p0.y*(1.0+2.0*(x-p0.x)/(p1.x-p0.x))*pow(((x-p1.x)/(p0.x-p1.x)), 2)+p1.y*(1.0+2.0*(x-p1.x)/(p0.x-p1.x))*pow(((x-p0.x)/(p1.x-p0.x)), 2)+rp0*(x-p0.x)*pow(((x-p1.x)/(p0.x-p1.x)), 2)+rp1*(x-p1.x)*pow(((x-p0.x)/(p1.x-p0.x)), 2);
    }
    
    /// 获取3次贝塞尔曲线函数方程
    /// - Parameters:
    ///   - p0: 开始点
    ///   - p1: 结束点
    ///   - c0: 控制点0
    ///   - c1: 控制点1
    ///   - t: 相对x取值区间 0<t<1
    /// - Returns: y
    static func fan_bezier(p0:Double,p1:Double,c0:Double,c1:Double,t:Double)->Double{
        return p0*pow((1.0-t), 3)+3.0*c0*t*pow((1.0-t), 2)+3.0*c1*pow(t, 2)*(1.0-t)+p1*pow(t, 3)
    }
    /// 获取3次贝塞尔曲线函数方程
    /// - Parameters:
    ///   - p0: 开始点
    ///   - p1: 结束点
    ///   - c0: 控制点0
    ///   - c1: 控制点1
    ///   - t: 相对x取值区间 0<t<1
    /// - Returns: y
    static func fan_bezierPoint(p0:CGPoint,p1:CGPoint,c0:CGPoint,c1:CGPoint,t:Double)->CGPoint{
        var b:CGPoint = CGPoint.zero;
        b.x = fan_bezier(p0: p0.x, p1: p1.x, c0: c0.x, c1: c1.x, t: t)
        b.y = fan_bezier(p0: p0.y, p1: p1.y, c0: c0.y, c1: c1.y, t: t)
        return b;
    }
}
//MARK: - WiFi地址相关
public extension FanTool {
//    en0/ipv4 = 192.168.0.40;
//    llw0/ipv6 = fe80::9851:47ff:fef8:4eec;
//    en2/ipv6 = fe80::1037:dd02:a7c5:d3b;
//    lo0/ipv6 = fe80::1;
//    awdl0/ipv6 = fe80::9851:47ff:fef8:4eec;
//    utun1/ipv6 = fe80::8fe5:9463:5f13:69d9;
//    en0/ipv6 = fe80::1494:848f:81f:76e7;
//    en2/ipv4 = 169.254.28.195;
//    lo0/ipv4 = 127.0.0.1;
//    utun0/ipv6 = fe80::6753:53a5:3753:2eb8
    
    /// 获取所有IP地址
    static func fan_allIPAddress() -> [String:String] {
        var addresses = [String:String]()
        var interfaces:UnsafeMutablePointer<ifaddrs>?
        // 获取网络接口列表
        if getifaddrs(&interfaces) == 0 {
            if let interfaces = interfaces {
                var faceP:UnsafeMutablePointer<ifaddrs>? = interfaces
                while faceP != nil {
                    if let face = faceP?.pointee {
                        let name = String(cString: face.ifa_name)
                        let flags = Int32(face.ifa_flags)
                        if ((flags & IFF_UP) == 0) {
//                            print("不符合的flags name：\(name)")
                            faceP = faceP?.pointee.ifa_next
                            continue
                        }

//                        if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                        }
                        //NI_MAXHOST = 1025  max= 46 INET_ADDRSTRLEN=16 INET6_ADDRSTRLEN=46
                        
                        let maxCount = max(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)
                        let family = face.ifa_addr.pointee.sa_family
                        if family == UInt8(AF_INET)  {
                            //存放Ip地址buffer
                            var addrBuf:[CChar] = [CChar](repeating: 0, count: Int(maxCount))
                            getnameinfo(face.ifa_addr, socklen_t(face.ifa_addr.pointee.sa_len), &addrBuf, socklen_t(addrBuf.count), nil, socklen_t(0), NI_NUMERICHOST)
                            let key = name + "/ipv4"
                            let value = String(cString: addrBuf)
//                            print("\(key):"+value)
                            addresses[key] = value
                            
                        }else if family == UInt8(AF_INET6) {
                            //存放Ip地址buffer
                            var addrBuf:[CChar] = [CChar](repeating: 0, count: Int(maxCount))
                            getnameinfo(face.ifa_addr, socklen_t(face.ifa_addr.pointee.sa_len), &addrBuf, socklen_t(addrBuf.count), nil, socklen_t(0), NI_NUMERICHOST)
                            let key = name + "/ipv6"
                            var value = String(cString: addrBuf)
                            value = value.replacingOccurrences(of: "%"+name, with: "")
//                            print("\(key):"+value)
                            addresses[key] = value
                            //一种转换方法
//                            var s6_addr = face.ifa_addr.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) {
//                                $0.pointee.sin6_addr.__u6_addr.__u6_addr8
//                            }
//                            //Swift 没有导入 netinet6/in6.h 定义宏
//                            //#define IN6_IS_ADDR_LINKLOCAL(a)   (((a)->s6_addr[0] == 0xfe) && (((a)->s6_addr[1] & 0xc0) == 0x80))
//                            if s6_addr.0 == 0xfe && (s6_addr.1 & 0xc0) == 0x80 {
//                            }
                        }
                    }
                    faceP = faceP?.pointee.ifa_next
                }
            }
        }
        freeifaddrs(interfaces)
        return addresses
    }
    /// 获取本机IP地址 默认是WiFi的ipv4
    static func fan_ipAddress(_ ipType:FanIPType = .wifiIpv4) -> String? {
        let dic = fan_allIPAddress()
        let ip = dic[ipType.rawValue]
        return ip
    }
}
