# CoordinateSystem
坐标系工具，让画圆，画弧一目了然。

UIBezierPath是对Core Graphics框架的一种上层封装，目的是让绘图需求可以被更方便的使用。
那你有没有发现被UIBezierPath封装后与之前有什么改变？
答：有三个变化。
1.屏蔽繁杂重复的内容
2.功能阉割
3.坐标系顺时针方向反转


##### 证明1:屏蔽繁杂重复的内容
相比Core Graphics框架，UIBezierPath帮我们做了一些繁琐的事件。比如有这样一个场景：需要画一个圆，但是它的每个1/4弧线的strokpath颜色是不同的。对于这样的需求。
有个错误的做法是：
1.拿到上下文
2.设置第一个1/4户的strokpath颜色，用上下文绘制第一个1/4弧
3.设置第一个2/4户的strokpath颜色，用上下文绘制第一个2/4弧
4.设置第一个3/4户的strokpath颜色，用上下文绘制第一个3/4弧
5.设置第一个4/4户的strokpath颜色，用上下文绘制第一个4/4弧
最后的结果会发现，这四段弧的颜色是最后一个4/4弧的strokpath的颜色
原因是：对于一个上下文来说，strokPathColor属性只有一个，虽然设置了4次，但总是后面的覆盖前面的。

一种解决方法是：
在第2步之前，先循环4次操作
```
let content = UIGraphicsGetCurrentContext()
content?.setStrokeColor(UIColor.blue.cgColor)
content?.saveGState()
```
然后在每一步绘制前，恢复上下文栈中的存储到当前上下文
`content?.restoreGState()`

##### 另一种解决方法是：
直接创建4个UIBezierPath，用贝塞尔曲线绘制着4段弧。
这样就很直观的看出，每个UIBezierPath的上下文都是独立的。内部帮我们自己做了上下文的存栈和出栈。


##### 证明2:功能阉割
虽然有了UIBezierPath的封装我们用起来方便了，但是相应的代价是所提供的功能被阉割了。有些强大的功能UIBezierPath没有提供实现，比如：现在要画一个圆形的渐变球，就只能使用Core Graphics框架。
代码如下
```
//利用上下文绘制渐变色（圆形）
let context = UIGraphicsGetCurrentContext()
//颜色空间
let colorSpace = CGColorSpaceCreateDeviceRGB()
let startColor = UIColor.black
let endColor = UIColor.red
//颜色数组
let colors = [startColor.cgColor,endColor.cgColor]
//颜色所处位置
let locations:[CGFloat] = [0,1]
let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as! CFArray, locations: locations)
let center = CGPoint(x: rect.size.width*0.5, y: rect.size.height*0.5)
let radius = rect.size.height*0.3
context?.drawRadialGradient(gradient!, startCenter: center, startRadius: radius*0.2, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)

```

##### 证明3:坐标系顺时针方向反转
你知道吗， CoreGraphics绘图系统和Bezier贝塞尔曲线坐标系的顺时针方向是相反的！
 
我记得上学时老师讲的坐标系是这样的： 


X轴指向右侧，Y轴指向上面。对应的弧度如图上标的那样。顺时针也是钟表表针转动的方向。这就是最早接触的坐标系，熟悉的单纯模样。

 

在工作时，当我们往屏幕上布局UI时，用到的坐标系是下面这样：


对于UI控件来讲的坐标系模式，X轴方向向右，Y轴方向向下。
请注意弧度值也相应的转了方向，它是沿着X，Y指向的方向开始逐渐增加的。
顺时针还是熟悉的钟表表针转动方向。
 
关键代码如下：

```
 let content = UIGraphicsGetCurrentContext()

        var endAngl = _progressValue*CGFloat(M_PI*2)
        var clockState = (_direction == .onTime)
       
        //圆
        var des: String = ""
        des = clockState ? "UIGraphics上下文绘制、顺时针" : "UIGraphics上下文绘制、逆时针”

        content?.move(to: CGPoint(x: width-arcRadius, y: height*0.5))
        let bez = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: 0, endAngle: endAngl, clockwise: clockState)
            content?.addPath(bez.cgPath)

        NSString(string: des).draw(in: CGRect(x: 2, y: 2, width: width*0.4, height: height*0.5), withAttributes: atts)
        log = String(format: "绘制弧度: %.4f Pi", endAngl/3.14)
        
        content?.strokePath()
```

实际效果图如下：


UIBezierPath顺时针模式下，从0到2PI的效果


UIBezierPath逆时针模式下，从0到2PI的效果
 

然后突出的CoreGraphics表示不服，我就要与众不同。如下图：


说出来你可能不信，你会发现顺时针方向往上了。这明明是逆时针方向啊！WTF？

来看下代码和实现效果吧。
```
let content = UIGraphicsGetCurrentContext()
 
 var endAngl = _progressValue*CGFloat(M_PI*2)
 var clockState = (_direction == .onTime)
 
 //圆
 var des: String = ""
 des = clockState ? "UIGraphics上下文绘制、顺时针" : "UIGraphics上下文绘制、逆时针”
 
 content?.move(to: CGPoint(x: width-arcRadius, y: height*0.5))
 content?.addArc(center: arcCenter, radius: arcRadius, startAngle: 0, endAngle: endAngl, clockwise: clockState)
 
 NSString(string: des).draw(in: CGRect(x: 2, y: 2, width: width*0.4, height: height*0.5), withAttributes: atts)
 log = String(format: "绘制弧度: %.4f Pi", endAngl/3.14)
  
 content?.strokePath()
```

实际效果如下：

CoreGraphics顺时针模式下，从0到2PI的效果


CoreGraphics逆时针模式下，从0到2PI的效果

 

CoreGraphics和Bezier贝塞尔曲线都是平时开发中的利器，认真品味一下两者的区别，会让我们对它们有更深的认识。

有讲的不对的地方欢迎指正。
