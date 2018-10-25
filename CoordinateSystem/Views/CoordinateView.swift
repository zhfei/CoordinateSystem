//
//  CoordinateView.swift
//  MyTestWorkProduct
//
//  Created by zhoufei on 2018/10/25.
//  Copyright © 2018年 zhoufei. All rights reserved.
//

import UIKit

enum CoordinateType {
    case UIGraphics
    case UIBezierPath
}

enum DirectionType {
    case onTime
    case unTime
}

class CoordinateView: UIView {
    //坐标系类型
    var _coordinateType: CoordinateType = CoordinateType.UIBezierPath
    var coordinateType: CoordinateType {
        get {
            return _coordinateType
        }
        set {
            _coordinateType = newValue
            setNeedsDisplay()
        }
    }
    //绘制弧度
    var _progressValue: CGFloat = 0
    var progressValue: CGFloat {
        get {
            return _progressValue
        }
        set {
            _progressValue = newValue
            setNeedsDisplay()
        }
    }
    //时针方向
    var _direction: DirectionType = DirectionType.onTime
    var direction: DirectionType {
        get {
            return _direction
        }
        set {
            _direction = newValue
            setNeedsDisplay()
        }
    }
    
    //日志
    //swift属性默认不支持kvo,需要在属性前收到加“dynamic”
    //或者在属性的willSet didSet方法中主动发送通知
    @objc dynamic var log: String = ""
    
    override func draw(_ rect: CGRect) {
        let height = rect.size.height
        let width = rect.size.width
        let partAnglewidth: CGFloat = 15
        let partAngleheight: CGFloat  = 10
        let arcRadius = height*0.3
        let arcCenter = CGPoint(x: width*0.5, y: height*0.5)
        let atts = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),
                    NSAttributedStringKey.foregroundColor:UIColor.blue]
        
        var endAngl = _progressValue*CGFloat(M_PI*2)
        var clockState = (_direction == .onTime)
        
        let content = UIGraphicsGetCurrentContext()
        //水平线
        content?.move(to: CGPoint(x: 0, y: height*0.5))
        content?.addLine(to: CGPoint(x: width, y: height*0.5))
        
        content?.addLine(to: CGPoint(x: width-partAnglewidth, y: height*0.5-partAngleheight))
        content?.move(to: CGPoint(x: width, y: height*0.5))
        content?.addLine(to: CGPoint(x: width-partAnglewidth, y: height*0.5+partAngleheight))
        NSString(string: "X").draw(at: CGPoint(x: width-partAnglewidth, y: height*0.5+partAngleheight), withAttributes: atts)
        
        //垂直线
        content?.move(to: CGPoint(x: width*0.5, y: height))
        content?.addLine(to: CGPoint(x: width*0.5, y: 0))
        
        content?.addLine(to: CGPoint(x: width*0.5-partAngleheight, y: partAnglewidth))
        content?.move(to: CGPoint(x: width*0.5, y: 0))
        content?.addLine(to: CGPoint(x: width*0.5+partAngleheight, y: partAnglewidth))
        NSString(string: "Y").draw(at: CGPoint(x: width*0.5+partAngleheight, y: 0), withAttributes: atts)
    
        
        //圆
        var des: String = ""
        switch _coordinateType {
        case .UIGraphics:
            des = clockState ? "UIGraphics上下文绘制、顺时针" : "UIGraphics上下文绘制、逆时针"
            content?.move(to: CGPoint(x: width-arcRadius, y: height*0.5))
            content?.addArc(center: arcCenter, radius: arcRadius, startAngle: 0, endAngle: endAngl, clockwise: clockState)
        case .UIBezierPath:
            des = clockState ? "UIBezierPath贝塞尔曲线绘制、顺时针" : "UIBezierPath贝塞尔曲线绘制、逆时针"
            let bez = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: 0, endAngle: endAngl, clockwise: clockState)
            content?.addPath(bez.cgPath)
        }
        NSString(string: des).draw(in: CGRect(x: 2, y: 2, width: width*0.4, height: height*0.5), withAttributes: atts)
        log = String(format: "绘制弧度: %.4f Pi", endAngl/3.14)
        
        content?.strokePath()
        
    }

}
