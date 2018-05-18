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
    func push(_ vc: UIViewController)
    func wirePanToDismissGestureInView(_ view: UIView)
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
        
        if let superview = view.superview {
            delegate?.wirePanToDismissGestureInView(superview)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print(#function)
    }
    
    @IBAction func tapOne(_ sender: Any) {
        let vc = SideMenuDetailViewController()
        vc.title = "皆非"
        show(vc)
    }
    
    @IBAction func tapTwo(_ sender: Any) {
        let vc = SideMenuDetailViewController()
        vc.title = "凉风有信"
        show(vc)
    }
    
    @IBAction func tapDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func show(_ vc: UIViewController) {
        dismiss(animated: true, completion: nil)
        presentingViewController?.show(vc, sender: nil)
        
//        delegate?.push(vc)
    }

    deinit {
        print("\(self) deinit")
    }
}


