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
    lazy var interactiveTransition = SideMenuInteractiveTransition()
    var presentationController: SideMenuPresentationController?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteracting ? interactiveTransition : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteracting ? interactiveTransition : nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if self.presentationController == nil {
            self.presentationController =  SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
        }
        return self.presentationController
    }
    
    deinit {
        print("\(self) deinit")
    }
}


