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


protocol SideMenuDelegate: class {
    /// 从SideMenuMainViewController中push侧边栏中的ViewController
    func pushViewControllerFromSideMenu(_ vc: UIViewController)
    /// 在SideMenuViewController显示完全后，为其关联滑动dismiss手势
    func wireDismissGestureInView(_ view: UIView)
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let superview = self.view.superview {
            delegate?.wireDismissGestureInView(superview)
        }
    }
  
    @IBAction func tapOne(_ sender: Any) {
        let vc = SideMenuDetailViewController()
        vc.title = "皆非"
        push(vc)
    }
    
    @IBAction func tapTwo(_ sender: Any) {
        let vc = SideMenuDetailViewController()
        vc.title = "凉风有信"
        push(vc)
    }
    
    @IBAction func tapDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func push(_ vc: UIViewController) {
        delegate?.pushViewControllerFromSideMenu(vc)
    }

    deinit {
        print("\(self) deinit")
    }
}


