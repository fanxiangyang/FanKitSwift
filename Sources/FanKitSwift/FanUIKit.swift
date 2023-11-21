//
//  File.swift
//  
//
//  Created by 向阳凡 on 2023/11/20.
//

import Foundation
import UIKit

// UIKit 全局调用方法

/// 颜色值rgb = (0-255)  a=0.x-1.0
func FanColor(_ r:Int,_ g:Int,_ b:Int,_ a:CGFloat = 1) -> UIColor {
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
}
/// 颜色值rgba 都小数点
func FanColorf(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat = 1) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: a)
}
/// 16进制转换成UIColor
func FanHexColor(_ hex: String,_ alpha:CGFloat = 1.0) -> UIColor {
    var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    if hexFormatted.hasPrefix("#") {
        hexFormatted = String(hexFormatted.dropFirst())
    }
    assert(hexFormatted.count == 6,"无效字符串,必须是6个字符串")
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
}
// 全局引用类快捷调用方法

