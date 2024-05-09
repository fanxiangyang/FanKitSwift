//
//  FanLayerTool.swift
//  
//
//  Created by 凡向阳 on 2024/4/12.
//

import UIKit




/// 轴-这种类似枚举的写法
public struct FanAxis : RawRepresentable {
    public var rawValue: String
    
    public init(rawValue: String){
        self.rawValue = rawValue
    }
    /// x轴
    public static let x:FanAxis = .init(rawValue: "x")
    /// y轴
    public static let y:FanAxis = .init(rawValue: "y")
    /// z轴
    public static let z:FanAxis = .init(rawValue: "z")
 
}

/// layer层动画+画Layer
@objcMembers public class FanLayerTool: NSObject {
    /// 所有的动画类型
    @objc public enum FanAnimationType:UInt {
        ///透明度闪烁
        case opacity
        /// x轴移动
        case moveX
        /// y轴移动
        case moveY
        /// z轴移动
        case moveZ
        /// 点移动-平面（x,y)
        case movePoint
        /// 缩放
        case scale
        /// transform3D旋转
        case transform3D
    }
    
    ///CABasicAnimation动画的keyPath类型
    public enum FanAnimationKey:String {
        case none = ""
        case opacity = "opacity"
        case moveX = "transform.translation.x"
        case moveY = "transform.translation.y"
        case moveZ = "transform.translation.z"
        case movePoint = "transform.translation"
        case scale = "transform.scale"
        case transform3D = "transform"
        public static func keyPath(type:FanAnimationType) -> Self {
            switch type {
            case .opacity:
                return .opacity
            case .moveX:
                return .moveX
            case .moveY:
                return .moveY
            case .moveZ:
                return .moveZ
            case .movePoint:
                return .movePoint
            case .scale:
                return .scale
            case .transform3D:
                return .transform3D
            default:
                return .none
            }
        }
    }
    //MARK: - Layer 动画
    
    /// 一般的导航翻页过渡动画
    /// - Parameters:
    ///   - type: 动画主要效果.init(rawValue: "cube") 3D立方体 cubic迅速透明移动 pageCurl 角翻页，pageUnCurl反翻页 rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转 【fade淡出，moveIn覆盖原图，push推出，reveal卷轴效果】
    ///   - subType: 子效果，动画方向
    ///   - duration: 动画时长
    /// - Returns: 动画
    public class func fan_transitionAnimation(type:CATransitionType,subType:CATransitionSubtype? = nil,duration:Double = 0.27) -> CATransition {
        let animation = CATransition()
        animation.type = type
        animation.subtype = subType
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return animation
    }
    
    //MARK: - CABasicAnimation动画
    /// 所有动画(动画类型是类似 transform.translation.x )
    /// - Parameters:
    ///   - keyPath: 动画类型
    ///   - from: 开始值
    ///   - to: 结束值
    ///   - duration: 时间
    ///   - repeatCount: 重复次数默认0  .greatestFiniteMagnitude 无限次数
    ///   - autoreverses: 是否逆向动画，默认NO
    ///   - cumulative: 是否累计 默认NO
    /// - Returns: 移动动画
    public class func fan_animation(keyPath:String?,from:Any?,to:Any?,duration:Double = 0.27,repeatCount:Float = 0, autoreverses:Bool = false,cumulative:Bool = false) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = duration
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        //        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        return animation
    }
    /// 所有动画（swift的写法）
    /// - Parameters:
    ///   - keyPath: 动画类型
    ///   - from: 开始值
    ///   - to: 结束值
    ///   - duration: 时间
    ///   - repeatCount: 重复次数默认0  .greatestFiniteMagnitude 无限次数
    ///   - autoreverses: 是否逆向动画，默认NO
    ///   - cumulative: 是否累计 默认NO
    /// - Returns: 移动动画
    public class func fan_animation(key:FanAnimationKey,from:Any?,to:Any?,duration:Double = 0.27,repeatCount:Float = 0,autoreverses:Bool = false,cumulative:Bool = false) -> CABasicAnimation {
        return fan_animation(keyPath: key.rawValue, from: from, to: to,duration: duration,repeatCount: repeatCount,autoreverses: autoreverses,cumulative: cumulative)
    }
    /// 所有动画（为了兼容OC的写法)
    /// - Parameters:
    ///   - keyPath: 动画类型
    ///   - from: 开始值
    ///   - to: 结束值
    ///   - duration: 时间
    ///   - repeatCount: 重复次数默认0  .greatestFiniteMagnitude 无限次数
    ///   - autoreverses: 是否逆向动画，默认NO
    ///   - cumulative: 是否累计 默认NO
    /// - Returns: 移动动画
    public class func fan_animation(type:FanAnimationType,from:Any?,to:Any?,duration:Double = 0.27,repeatCount:Float = 0,autoreverses:Bool = false,cumulative:Bool = false) -> CABasicAnimation {
        let animation = fan_animation(key: .keyPath(type: type), from: from, to: to,duration: duration,repeatCount:repeatCount,autoreverses: autoreverses,cumulative: cumulative)
        
        return animation
    }
    /// 带路径的自定义动画 position
    /// - Parameters:
    ///   - path: 路径
    ///   - duration: 时间
    ///   - repeatCount: 执行次数 默认0
    ///   - autoreverses: 是否逆向动画，默认false
    ///   - cumulative: 是否累计 默认false
    /// - Returns: CAKeyframeAnimation
    public class func fan_animationKeyFrame(path:CGPath?,duration:Double,repeatCount:Float = 0, autoreverses:Bool = false,cumulative:Bool = false) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.values = nil
        animation.path = path
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = duration
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        //        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        return animation
    }
}
//MARK: - Layer画图（画线，画矩形，渐变，镂空）
/// 画图Layer
public extension FanLayerTool {
    /// 画直线Layer
    /// - Parameters:
    ///   - lineWidth: 线宽
    ///   - lineColor: 线颜色
    ///   - start: 开始点
    ///   - end: 结束点
    /// - Returns: Layer
    class func fan_layer(lineWidth:CGFloat,lineColor:UIColor,start:CGPoint, end:CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.strokeColor = lineColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        layer.path = path.cgPath
        return layer
    }
    /// 画虚线Layer
    /// - Parameters:
    ///   - lineWidth: 线宽
    ///   - lineColor: 线颜色
    ///   - start: 开始点
    ///   - end: 结束点
    ///   - dashedWidth: 虚线实体的宽度
    ///   - dashedSpace: 虚线间距宽度 默认4
    /// - Returns: Layer
    class func fan_layer(lineWidth:CGFloat,lineColor:UIColor,start:CGPoint, end:CGPoint,dashedWidth:CGFloat, dashedSpace:CGFloat = 4) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.strokeColor = lineColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [NSNumber(value: dashedWidth), NSNumber(value: dashedSpace)]
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        layer.path = path.cgPath
        return layer
    }
    /// 画自定义路径 直线 Layer(是否虚线）
    /// - Parameters:
    ///   - frame: layer的frame
    ///   - path: UIBezierPath曲线（曲线在frame坐标内）
    ///   - lineWidth: 线宽
    ///   - lineColor: 线颜色
    ///   - dashPattern: 虚线数组（实线宽+间隔宽）
    /// - Returns: Layer
    class func fan_layer(frame:CGRect, path:UIBezierPath, lineWidth:CGFloat,lineColor:UIColor,dashPattern:[NSNumber]? = nil) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.strokeColor = lineColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path.cgPath
        layer.frame = frame
        return layer
    }
    /// 画自定义路径图形 Layer
    /// - Parameters:
    ///   - frame: layer的frame
    ///   - path: UIBezierPath曲线（曲线在frame坐标内）
    ///   - fillColor: 填充颜色
    /// - Returns: Layer
    class func fan_layer(frame:CGRect ,path:UIBezierPath, fillColor:UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = fillColor.cgColor
        layer.frame = frame;
        layer.path = path.cgPath
        return layer
    }
    
    /// 画圆环（右边是0度，顺时针360为UI坐标）
    /// - Parameters:
    ///   - frame: layer的frame
    ///   - center: 相对layer的frame的中心点
    ///   - radius: 半径
    ///   - startAngle: 开始的角度
    ///   - ringWidth: 圆环宽度
    ///   - ringColor: 圆环颜色
    ///   - clockwise: 是否是顺时针 ，默认true
    /// - Returns: CAShapeLayer
    class func fan_layer(frame:CGRect,center:CGPoint,radius:CGFloat,startAngle:CGFloat,ringWidth:CGFloat,ringColor:UIColor,clockwise:Bool = true) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = ringWidth
        layer.lineCap = .round
        layer.strokeColor = ringColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle:startAngle, endAngle: startAngle+(.pi)*2.0*(clockwise ? 1.0 : -1.0), clockwise: clockwise)
        layer.path = path.cgPath
        layer.frame = frame
        return layer
    }
    
    /// 生成渐变Layer
    /// - Parameters:
    ///   - frame: layer的尺寸
    ///   - colors: 渐变色彩
    ///   - locations: 区间（nil = 均匀分布) 例如 [0,1]
    ///   - endPoint: 开始点（0,0）结束点  垂直（0,1）水平（1,0）
    ///   - cornerRadius: 圆角半径
    /// - Returns: 渐变色Layer
    class func fan_layer(frame:CGRect,colors:[UIColor]?,locations:[NSNumber]?,endPoint:CGPoint,cornerRadius:CGFloat) -> CAGradientLayer {
        var refColors:[CGColor] = []
        if let colors = colors {
            for color in colors {
                refColors.append(color.cgColor)
            }
        }
        let layer = CAGradientLayer()
        layer.colors = refColors
        layer.locations = locations
        layer.cornerRadius = cornerRadius
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = endPoint
        layer.frame = frame
        return layer
    }
    
    /// 获取镂空maskLayer
    /// - Parameters:
    ///   - bounds: 镂空Layer的bounds
    ///   - cutoutFrame: 镂空的frame
    ///   - cornerRadius: 圆角 默认=0
    /// - Returns: 镂空Layer
    class func fan_layer(bounds:CGRect ,cutoutFrame:CGRect,cornerRadius:CGFloat = 0) -> CAShapeLayer {
        return fan_layer(bounds: bounds, cutoutPath: UIBezierPath(roundedRect: cutoutFrame, cornerRadius: cornerRadius))
    }
    /// 获取镂空maskLayer
    /// - Parameters:
    ///   - bounds: 镂空Layer的bounds
    ///   - cutoutPath: 镂空路径自定义
    /// - Returns: 镂空Layer
    class func fan_layer(bounds:CGRect ,cutoutPath:UIBezierPath) -> CAShapeLayer {
        let path = UIBezierPath(rect: bounds)
        path.append(cutoutPath.reversing())
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        return layer
    }
}
