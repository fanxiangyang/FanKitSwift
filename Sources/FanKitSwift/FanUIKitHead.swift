//
//  FanUIKitHead.swift
//  
//
//  Created by 向阳凡 on 2023/11/20.
//

import Foundation
import UIKit

//MARK: -  UIKit 全局调用方法

//MARK: -  UIColor 颜色相关
/// 颜色值rgb = (0-255)  a=0.x-1.0
public func FanColor(_ r:Int,_ g:Int,_ b:Int,_ a:CGFloat = 1) -> UIColor {
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
}
/// 颜色值rgba 都小数点
public func FanColorf(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat = 1) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: a)
}
///白色color
public func FanColor(white alpha:CGFloat) -> UIColor{
    return UIColor(white: 1.0, alpha: alpha)
}
/// 黑色color
public func FanColor(black alpha:CGFloat) -> UIColor{
    return UIColor.black.withAlphaComponent(alpha)
}
/// 16进制转换成UIColor
public func FanColor(hex: String,_ alpha:CGFloat = 1.0) -> UIColor {
    var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    if hexFormatted.hasPrefix("#") {
        hexFormatted = String(hexFormatted.dropFirst())
    }
    assert(hexFormatted.count == 6,"无效字符串,必须是6个字符串")
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
}
/// UIColor转换成 #ffffff
public func FanHexString(_ color: UIColor) -> String {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    let success = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    if success {
        let rgbString = String(format: "#%02x%02x%02x", Int(red * 255.0), Int(green * 255.0), Int(blue * 255.0))
        return rgbString
    }
    return "#ffffff"
}
//MARK: -  UIFont相关方法
/// 系统常规字体
public func FanFont(_ size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}
/// 系统中粗体
public func FanFont(medium size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: .medium)
}
/// 系统粗体
public func FanFont(bold size:CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}
public func FanFont(semibold size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: .semibold)
}
/// 自定义字体名称
public func FanFont(name:String, size:CGFloat) -> UIFont {
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: 14)
}
//MARK: -  UIImage Bundle 获取图片相关
///获取图片，可以读取asset.xcassets里面的图片
public func FanImage(_ name:String) -> UIImage? {
    return UIImage(named: name)
}
///自动获取图片全路径
public func FanImage(path:String) -> UIImage? {
    return UIImage(contentsOfFile: path)
}
///自动获取图片全路径-bundle
public func FanImage(allName : String) -> UIImage? {
    return UIImage(contentsOfFile: FanPath(fileAllName: allName))
}
///自动获取图片全路径-bundle
public func FanImage(onlyName : String) -> UIImage? {
    return UIImage(contentsOfFile: FanPath(fileName: onlyName))
}
///获取自定义bundle里面的图片
public func FanImage(bundleName : String,fileName:String) -> UIImage? {
    return UIImage(contentsOfFile: FanPath(bundleName: bundleName, fileName: fileName))
}

//MARK: -  全局引用类快捷调用方法或属性
/// 屏幕宽
@MainActor public var FanWidth : CGFloat {
    get {
        return FanUIKitTool.fan_width
    }
}
///屏幕高
@MainActor public var FanHeight : CGFloat {
    get {
        return FanUIKitTool.fan_height
    }
}
