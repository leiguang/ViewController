//
//  SideMenuViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

/// 侧边栏的宽度
var kSideMenuWidth: CGFloat { return ceil(UIScreen.main.bounds.width * 0.8) }
/// present时，x轴滑动偏移多少，触发present (带方向，单位pt)
let kPanPresentSideMenuOffsetX: CGFloat = 100
/// dismiss时，x轴滑动偏移多少，触发dismiss (带方向，单位pt)
let kPanDismissSideMenuOffsetX: CGFloat = -100
/// present时，x轴滑动速度达到多少，触发present (带方向，单位pt/s)
let kPanPresentSideMenuVelocityX: CGFloat = 800
/// dismiss时，x轴滑动速度达到多少，触发dismiss (带方向，单位pt/s)
let kPanDismissSideMenuVelocityX: CGFloat = -800


class SideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        print("\(self) deinit")
    }
}


