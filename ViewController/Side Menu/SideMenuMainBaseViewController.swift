//
//  SideMenuMainBaseViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuMainBaseViewController: UIViewController, SideMenuDelegate {

    let sideMenuTransitioning = SideMenuTransitioning()
    
    lazy var menuViewController: SideMenuViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.sideMenuTransitioning
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sideMenuTransitioning.interactiveTransition.addPresentGestureInView(self.view, presentingVC: self, presentedVC: self.menuViewController)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        checkAvailableOfInteractiveGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        checkAvailableOfInteractiveGesture()
    }
    
    /// 设置UINavigationController自带的边缘侧滑返回手势是否可用
    private func checkAvailableOfInteractiveGesture() {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.count < 3 {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            } else {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }

    // MARK: - SideMenuDelegate
    func pushViewControllerFromSideMenu(_ vc: UIViewController) {
        // 为防止直接调用，show的时候 不走SideMenuMainViewController的viewWillDisappear、viewDidDisappear方法。
        // To avoid overlapping dismiss & pop/push calls, create a transaction block where the menu is dismissed after showing the appropriate screen
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.menuViewController.dismiss(animated: true, completion: nil)
        }
        
        navigationController?.view.frame.origin.x = 0
        sideMenuTransitioning.presentationController?.dimmingView.alpha = 0
        menuViewController.view.frame.origin.x = -kSideMenuWidth
        show(vc, sender: nil)
        
        CATransaction.commit()
    }
    
    func wireDismissGestureInView(_ view: UIView) {
        self.sideMenuTransitioning.interactiveTransition.addDismissGestureInView(view)
    }

    deinit {
        print("\(self) deinit")
    }
}

