//
//  SideMenuPresentationController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuPresentationController: UIPresentationController {
    
    let dimmingView: UIView
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        self.dimmingView = UIView()
        self.dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        self.dimmingView.alpha = 0.0
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDimmingView))
        self.dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapDimmingView(_ tap: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerSize = self.containerView?.bounds.size else { return .zero }
        let presentedFrame = CGRect(x: 0, y: 0, width: kSideMenuWidth, height: containerSize.height)
        return presentedFrame
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }

        self.dimmingView.frame = containerView.bounds
        self.dimmingView.alpha = 0.0
        containerView.insertSubview(self.dimmingView, at: 0)
        
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 0.0
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
}
