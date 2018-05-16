//
//  SideMenuAnimator.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view else {
                fatalError("无法找到fromVC或toVC")
        }
        
        let containerView = transitionContext.containerView
        
        // present：true；  dismiss：false
        let presenting: Bool = (fromVC.presentedViewController == toVC)
        
        let containerFrame = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        var toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        
        if presenting {
            fromViewFinalFrame.origin.x = kSideMenuWidth
            toViewStartFrame = CGRect(x: -containerFrame.width, y: 0, width: kSideMenuWidth, height: containerFrame.height)
            toViewFinalFrame = CGRect(x: 0, y: 0, width: kSideMenuWidth, height: containerFrame.height)
        } else {
            fromViewFinalFrame.origin.x = -containerFrame.width
            toViewFinalFrame.origin.x = 0
        }
        
        if presenting {
            toView.frame = toViewStartFrame
            containerView.insertSubview(toView, aboveSubview: fromView)
        } else {
            containerView.insertSubview(fromView, aboveSubview: toView)
        }
        
        //        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            if presenting {
                fromView.frame = fromViewFinalFrame
                toView.frame = toViewFinalFrame
            } else {
                fromView.frame = fromViewFinalFrame
                toView.frame = toViewFinalFrame
            }
        }) { (_) in
            let cancelled = transitionContext.transitionWasCancelled
            if presenting && cancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancelled)
        }
    }
    
    override init() {
        super.init()
        print("\(self) init")
    }
    
    deinit {
        print("\(self) deinit")
    }
}

