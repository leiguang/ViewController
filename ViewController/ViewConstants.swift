//
//  ViewConstants.swift
//  IeltsBro
//
//  Created by 雷广 on 2018/4/17.
//  Copyright © 2018年 Chutzpah. All rights reserved.
//

import UIKit

/// 屏幕宽度
var kScreenWidth: CGFloat { return UIScreen.main.bounds.width }

/// 屏幕高度
var kScreenHeight: CGFloat { return UIScreen.main.bounds.height }

/// 状态栏高度（非iPhone X：StatusBar 高20pt； iPhone X：StatusBar 高44pt）
var kStatusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.height }

/// navigationBar高度 (44.0)
let kNaviBarHeight: CGFloat = 44.0

/// 导航栏高度 （非iPhone X：高64pt； iPhone X：高88pt）
let kNaviHeight: CGFloat = kStatusBarHeight + kNaviBarHeight

/// tabBarController高度 （非iPhone X：底部TabBar高49px； iPhone X：底部TabBar高83pt）
let kTabBarHeight: CGFloat = kDevice_isIphoneX ? (49.0 + 34.0) : 49.0

/// 顶部安全区域距离 （非iPhone X：20； iPhone X：44pt，同导航栏高度）
let kSafeAreaTop: CGFloat = kDevice_isIphoneX ? 44.0 : 20.0

/// 底部安全区域 距离 （非iPhone X：0pt； iPhone X：34pt）
let kSafeAreaBottom: CGFloat = kDevice_isIphoneX ? 34.0 : 0.0

/// 安全区域上下间距和
let kSafeAreaVerticalPadding = kSafeAreaTop + kSafeAreaBottom

/// 安全区域左右间距和
let kSafeAreaHorizonPadding = 0

/// 是否是iPhone X
var kDevice_isIphoneX: Bool { return (UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.height == 812) }

///背景半透明度
let translucentBackgroundAlpha: CGFloat = 0.5

