//
//  NavigationBackgroundLayer.swift
//  IeltsBro
//
//  Created by 雷广 on 2018/4/27.
//  Copyright © 2018年 Chutzpah. All rights reserved.
//

import UIKit

/// 屏幕宽度
var kScreenWidth: CGFloat { return UIScreen.main.bounds.width }
/// 状态栏高度（非iPhone X：StatusBar 高20pt； iPhone X：StatusBar 高44pt）
var kStatusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.height }
/// navigationBar高度 (44.0)
let kNaviBarHeight: CGFloat = 44.0
/// 导航栏高度 （非iPhone X：高64pt； iPhone X：高88pt）
let kNaviHeight: CGFloat = kStatusBarHeight + kNaviBarHeight

/// 导航栏 渐变layer
class NavigationBackgroundLayer: CAGradientLayer {
    override init() {
        super.init()
        
        //        colors = [UIColor(red: 15.0/255.0, green: 159.0/255.0, blue: 253.0/255.0, alpha: 1).cgColor,
        //                  UIColor(red: 0, green: 210/255.0, blue: 1, alpha: 1).cgColor]
        colors = [UIColor(red: 0, green: 210/255.0, blue: 1, alpha: 1).cgColor, UIColor(red: 15.0/255.0, green: 159.0/255.0, blue: 253.0/255.0, alpha: 1).cgColor]
        startPoint = CGPoint(x: 0.1, y: 0)          // 0.1是添加的大概偏移量
        endPoint = CGPoint(x: 0.1 + 0.57735, y: 1)  // 颜色值倾斜120°
    }
    
    // 当使用隐式动画的时候，init(layer: AnyObject)这个指定构造方法会被调用
    // 由于重写了init()指定构造器后，init(layer: Any)指定构造器就不会被自动继承，因此这个也得重写
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 导航栏 渐变image (宽：屏幕宽；高：导航栏+状态栏)
let NavigationBackgroundImage: UIImage = {
    let size = CGSize(width: kScreenWidth, height: kNaviHeight)
    let layer = NavigationBackgroundLayer()
    layer.frame = CGRect(origin: .zero, size: size)
    
    UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
    guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
    layer.render(in: ctx)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}()
