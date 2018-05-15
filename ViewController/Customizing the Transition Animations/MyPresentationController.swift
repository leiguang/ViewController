//
//  MyPresentationController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/15.
//  Copyright © 2018年 leiguang. All rights reserved.
//
import UIKit

/**
 为简单起见，只是在"AddInteractivityToTransitionsViewController.swift"的基础上，增加一个自定义的PresentationController。
 要看到PresentationController的效果，需要：
 1. 在“AddInteractivityToTransitionsViewController.swift” -> "func tapTransition()"中设置呈现风格为custom（解除注释“vc.modalPresentationStyle = .custom”）
 2. 在"AddInteractivityToTransitionsViewController.swift" -> "class MyTransitioning" 中增加实现方法“func presentationController(...)” (解除注释)
 */
class MyPresentationController: UIPresentationController {
    
    private let dimmingView: UIView
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        // Create the dimming view and set its initial appearance.
        self.dimmingView = UIView()
        self.dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        self.dimmingView.alpha = 0
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = self.containerView?.bounds else { return .zero }
        var presentedViewFrame: CGRect = .zero
        presentedViewFrame.size = CGSize(width: containerBounds.width * 0.8, height: containerBounds.height)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        return presentedViewFrame
    }
    
    override func presentationTransitionWillBegin() {
        // Get critical information about the presentation.
        guard let containerView = self.containerView else { return }
        
        // Set the dimming view to the size of the container's bounds, and make it transparent initially.
        self.dimmingView.frame = containerView.bounds
        self.dimmingView.alpha = 0
        
        // Insert the dimming view below everything else.
        containerView.insertSubview(self.dimmingView, at: 0)
        
        // Set up the animations for fading in the dimming view.
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                // Fade in the dimming view.
                self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1.0
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If the presentation was cancelled, remove the dimming view.
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // Fade the dimming view back out.
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // If the dismissal was successful, remove the dimming view.
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
}
