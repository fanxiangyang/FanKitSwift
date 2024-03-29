//
//  File.swift
//  
//
//  Created by 凡向阳 on 2024/3/22.
//

import Foundation
import UIKit

//MARK: - 图片扩展方法
public extension UIImage {
    
    //MARK: - 图片缩放裁剪
    
    /// 等比填充图片-会裁剪
    /// - Parameters:
    ///   - maxSize: 生成的图片大小
    ///   - autoScale: 是否自动屏幕倍数图片
    ///   - scale: 图片是几倍图 请填写 1,2,3等
    /// - Returns: 生成新图片
    func fan_scaleAspectFill(maxSize:CGSize,autoScale:Bool = true,scale:CGFloat = 2.0) -> UIImage? {
        let imageSize  = self.size
        var sw = maxSize.width
        var sh = maxSize.height
        var originPoint = CGPointZero
        if imageSize.equalTo(maxSize) == false {
            let sfw = maxSize.width/imageSize.width
            let sfh = maxSize.height/imageSize.height
            let scaleFactor = max(sfw, sfh);
            sw = imageSize.width * scaleFactor
            sh = imageSize.height * scaleFactor
            if sfw > sfh {
                originPoint.y = (maxSize.height - sh)*0.5
            }else{
                originPoint.x = (maxSize.width - sw)*0.5
            }
        }
        let drawRect = CGRect(origin: originPoint, size: CGSize(width: sw, height: sh))
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        //是否用自动屏幕倍数生成图片倍数
        if autoScale == false {
            format.scale = scale;
        }
        let render = UIGraphicsImageRenderer(size: maxSize, format: format)
        let scaledImage = render.image { context in
            self .draw(in: drawRect)
        }
        return scaledImage
    }
    /// 等比适配图片-只缩放不裁剪
    /// - Parameters:
    ///   - maxSize: 生成的图片大小
    ///   - autoScale: 是否自动屏幕倍数图片
    ///   - scale: 图片是几倍图 请填写 1,2,3等
    /// - Returns: 生成新图片
    func fan_scaleAspectFit(maxSize:CGSize,autoScale:Bool = true,scale:CGFloat = 2.0) -> UIImage? {
        let imageSize  = self.size
        var sw = maxSize.width
        var sh = maxSize.height
        if imageSize.equalTo(maxSize) == false {
            let sfw = maxSize.width/imageSize.width
            let sfh = maxSize.height/imageSize.height
            let scaleFactor = min(sfw, sfh);
            sw = imageSize.width * scaleFactor
            sh = imageSize.height * scaleFactor
        }
        let drawRect = CGRect(origin: CGPointZero, size: CGSize(width: sw, height: sh))
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        //是否用自动屏幕倍数生成图片倍数
        if autoScale == false {
            format.scale = scale;
        }
        let render = UIGraphicsImageRenderer(size: drawRect.size, format: format)
        let scaledImage = render.image { context in
            self .draw(in: drawRect)
        }
        return scaledImage
    }
    
    /// 不变形裁剪
    /// - Parameters:
    ///   - maxSize: 裁剪放大的容器大小
    ///   - clipRect: 在容器内的frame，要小于maxSize
    ///   - isOval: 是否圆角
    ///   - autoScale: 是否自动生成屏幕倍数，默认true
    ///   - scale: 屏幕倍数
    /// - Returns: 新的裁剪图片
    func fan_clip(maxSize:CGSize,clipRect:CGRect,isOval:Bool = false, autoScale:Bool = true,scale:CGFloat = 2.0) -> UIImage? {
        let imageSize  = self.size
        let sfw = imageSize.width/maxSize.width
        let sfh = imageSize.height/maxSize.height
        let rec =  CGRect(x: clipRect.origin.x*sfw, y: clipRect.origin.y*sfh, width: clipRect.size.width*sfw, height: clipRect.size.height*sfh)
        let drawRect = CGRect(origin: CGPointZero, size: rec.size)
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        //是否用自动屏幕倍数生成图片倍数
        if autoScale == false {
            format.scale = scale;
        }
        let render = UIGraphicsImageRenderer(size: rec.size, format: format)
        let clipImage = render.image { context in
            if isOval {
                let bPath = UIBezierPath(ovalIn: drawRect)
                bPath .addClip()
            }
            self.draw(at: CGPoint(x: -rec.origin.x, y: -rec.origin.y))
        }
        return clipImage
    }
    ///裁剪图片，区域要小于图片size,保留原图片的倍数和方向
    func fan_clip(clipRect:CGRect) -> UIImage? {
        guard let imageRef = self.cgImage else {
            return nil
        }
        let scale = self.scale
        let x = clipRect.origin.x * scale
        let y = clipRect.origin.y * scale
        let width = clipRect.size.width * scale
        let height = clipRect.size.height * scale
        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        
        guard let imageRefCreate = imageRef.cropping(to: croppingRect) else {
            return nil
        }
        let clipImage = UIImage(cgImage: imageRefCreate,scale: scale, orientation: self.imageOrientation)
        return clipImage
    }
    ///9宫格图片 edge 图片保留上下左右区域不拉伸
    func fan_stretch(edge:UIEdgeInsets,resizingMode: UIImage.ResizingMode = .stretch) -> UIImage{
        return self.resizableImage(withCapInsets: edge, resizingMode: resizingMode)
    }
    //MARK: - 图片工具类方法
    
    /// 根据颜色生成一个图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    ///   - cornerRadius: 圆角
    ///   - autoScale: 是否自动屏幕倍数
    ///   - scale: 图片倍数，默认屏幕倍数
    /// - Returns: 图片
    static func fan_image(color:UIColor,size:CGSize,cornerRadius:CGFloat = 0.0, autoScale:Bool = true,scale:CGFloat = 2.0) -> UIImage? {
       
        let drawRect = CGRect(origin: CGPointZero, size: size)
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        //是否用自动屏幕倍数生成图片倍数
        if autoScale == false {
            format.scale = scale;
        }
        let render = UIGraphicsImageRenderer(size: size, format: format)
        let colorImage = render.image { context in
            color.setFill()
            if cornerRadius > 0.0 {
                let bPath = UIBezierPath(roundedRect: drawRect, cornerRadius: cornerRadius)
                bPath.addClip()
            }
            UIRectFill(drawRect)
        }
        return colorImage
    }
    
    /// View截图-AVPlayerLayer不支持了
    /// - Parameters:
    ///   - snapshotView: 截图的View
    ///   - autoScale: 是否自动屏幕倍数图片-默认true
    ///   - scale: 缩放倍数，默认2倍图
    /// - Returns: 截图图片
    static func fan_image(snapshotView:UIView?, autoScale:Bool = true,scale:CGFloat = 2.0) -> UIImage? {
        guard let snapshotView  = snapshotView else {
            return nil
        }
        let drawRect = snapshotView.bounds
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        //是否用自动屏幕倍数生成图片倍数
        if autoScale == false {
            format.scale = scale;
        }
        let render = UIGraphicsImageRenderer(size: drawRect.size, format: format)
        let snapshotImage = render.image { context in
            snapshotView.drawHierarchy(in: drawRect, afterScreenUpdates: true)
        }
        return snapshotImage
    }
    /// Layer截图-普通View的Layer(不包含播放器或Metal渲染的)
    /// - Parameters:
    ///   - snapshotLayer: Layer
    ///   - renderSize: 重绘大小
    ///   - autoScale: 是否自动倍数
    ///   - scale: 屏幕倍数
    /// - Returns: 截图
    static func fan_image(snapshotLayer:CALayer,renderSize:CGSize, autoScale:Bool = true,scale:CGFloat = 2.0) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        //是否用自动屏幕倍数生成图片倍数
        if autoScale == false {
            format.scale = scale;
        }
        let render = UIGraphicsImageRenderer(size: renderSize, format: format)
        let snapshotImage = render.image { context in
            snapshotLayer.render(in: context.cgContext)
        }
        return snapshotImage
    }
    
    //MARK: - 图片高斯模糊
    /// 高斯模糊大小-图片会变大(建议0-3)
    /// - Parameter blur: 模糊度 0-10
    /// - Returns: 模糊图片
    func fan_gaussianBlur(_ blur:CGFloat) -> UIImage? {
//        print("原图图片大小\(self.size) scale:\(self.scale)")
        let cImage = CIImage(image: self)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(cImage, forKey: kCIInputImageKey)
        //        print("\(filter?.value(forKey: "inputRadius"))")
        filter?.setValue(blur, forKey: kCIInputRadiusKey)
        guard let result:CIImage = filter?.outputImage else {
            return nil
        }
        let content = CIContext(options: nil)
        //result.extent生成的图片稍微偏大一点
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: self.size.width*self.scale, height: self.size.height*self.scale))
        guard let outImage = content.createCGImage(result, from: rect) else {
            return nil
        }
        let blurImage = UIImage(cgImage: outImage,scale: self.scale,orientation: self.imageOrientation)
//        print("图片大小\(blurImage.size) scale:\(blurImage.scale)")
        return blurImage
    }

}
