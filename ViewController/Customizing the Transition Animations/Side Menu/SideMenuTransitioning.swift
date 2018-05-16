//
//  SideMenuTransitioning.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuTransitioning: NSObject, UIViewControllerTransitioningDelegate {
    
    lazy var animator = SideMenuAnimator()
    lazy var interactiveTransitioning = SideMenuDrivenInteractiveTransition()
    var presentationController: SideMenuPresentationController?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning.isInteracting ? interactiveTransitioning : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning.isInteracting ? interactiveTransitioning : nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if self.presentationController == nil {
            self.presentationController = SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
        }
        return self.presentationController
    }
    
    override init() {
        super.init()
        print("\(self) init")
    }
    
    deinit {
        print("\(self) deinit")
    }
}


