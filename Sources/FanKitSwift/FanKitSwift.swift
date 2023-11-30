
import Foundation

//MARK: -  全局调用方法

/// 本地话语言
public func FanString(key:String) -> String{
    return NSLocalizedString(key, comment: key)
}
/// 本地话语言Table
public func FanStringTable(key:String,tab:String?) -> String{
    return NSLocalizedString(key,tableName: tab, comment: key)
}
//MARK: -  Bundle 获取文件路径
///自动获取bundle全名路径 user@2x.png(有子文件夹)  -bundle
public func FanPath(fileAllName fileName:String,subPath:String? = nil) -> String {
    if (subPath != nil) {
        return Bundle.main.path(forResource: fileName.fan_fileName , ofType: fileName.fan_pathExtension ,inDirectory: subPath) ?? ""
    }else{
        return Bundle.main.path(forResource: fileName.fan_fileName , ofType: fileName.fan_pathExtension) ?? ""
    }
}
///自动获取@2x,@3x图片路径(只有文件名)  -bundle
public func FanPath(fileName:String) -> String {
    return Bundle.main.resourcePath?.appending("/\(fileName)") ?? ""
}
/// 获取自定义bundle
public func FanBundle(_ name:String) -> Bundle? {
    let path = Bundle.main.path(forResource: name , ofType: "bundle") ?? ""
    return Bundle(path: path)
}
/// 获取自定义bundle里面的资源
public func FanPath(bundleName:String,fileName:String) -> String {
    return FanBundle(bundleName)?.resourcePath?.appending("/\(fileName)") ?? ""
}

//MARK: -  全局引用类快捷调用方法




public struct FanKitSwift {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}
