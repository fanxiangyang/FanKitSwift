//
//  File.swift
//  
//
//  Created by 凡向阳 on 2024/4/8.
//

import Foundation
import UIKit


/// 可变富文本扩展
@objc public extension NSMutableAttributedString {
    
    @discardableResult
    /// 修改字体大小+字体颜色
    func fan_add(font:UIFont? = nil,textColor:UIColor? = nil) -> Self {
        var attributes = [NSAttributedString.Key:Any]()
        if let font = font {
            attributes[.font] = font
        }
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return self
    }
    @discardableResult
    ///添加下划线
    func fan_add(underline:NSUnderlineStyle) -> Self{
        self.addAttribute(.underlineStyle, value: underline.rawValue, range: NSRange(location: 0, length: self.length))
        return self
    }
    @discardableResult
    ///添加段落格式
    func fan_add(paragraphStyle:NSMutableParagraphStyle) -> Self{
        self.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.length))
        return self
    }
    @discardableResult
    /// 追加富文本
    func fan_append(string:String,font:UIFont,textColor:UIColor) -> Self{
        self.append(NSAttributedString(string: string, attributes: [.font:font,.foregroundColor:textColor]))
        return self
    }
}


@objc public extension NSMutableParagraphStyle {
    ///初始化布局
    convenience init(alignment:NSTextAlignment){
        self.init()
        self.alignment = alignment
    }
}

public extension NSAttributedString {
    ///获取富文本大小
    func fan_size(maxSize:CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
    }
}
