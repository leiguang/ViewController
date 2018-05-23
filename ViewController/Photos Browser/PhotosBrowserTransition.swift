//
//  PhotosBrowserTransition.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/22.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class PhotosBrowserTransition: UIPercentDrivenInteractiveTransition {   // It maybe used later for interactive transitioning.
    
    /// temporary photo for making a present/dismiss transition.
    var tempImageView: UIImageView?
    
}

extension PhotosBrowserTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension PhotosBrowserTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view else {
                fatalError("无法找到fromVC或toVC")
        }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .clear
        
        // present: true;   dismiss: false
        let presenting: Bool = (fromVC.presentedViewController == toVC)
        
        if presenting {
            if let photoBrowserVC = toVC as? PhotosBrowserViewController,
                let image = photoBrowserVC.imageOfPresent,
                let startRect = photoBrowserVC.imageStartFrameOfPresent,
                let imageView = photoBrowserVC.currentImageView
            {
                tempImageView = UIImageView(image: image)
                tempImageView?.frame = startRect
                toView.addSubview(tempImageView!)
                imageView.isHidden = true
            }
            toView.alpha = 0
            containerView.addSubview(toView)
            
        } else {
            if let photoBrowserVC = fromVC as? PhotosBrowserViewController,
                let imageView = photoBrowserVC.currentImageView,
                let image = imageView.image,
                let startRect = photoBrowserVC.imageStartFrameOfDismiss
            {
                tempImageView = UIImageView(image: image)
                tempImageView?.frame = startRect
                fromView.addSubview(tempImageView!)
                imageView.isHidden = true
            }
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0.05,  // HACK: If zero, the animation briefly flashes in iOS 11. UIViewPropertyAnimators (iOS 10+) may resolve this. [Reference from SideMenu(GitHub)]
                       options: [],
                       animations: {
                        
                        if presenting {
                            if let photoBrowserVC = toVC as? PhotosBrowserViewController,
                                let endRect = photoBrowserVC.imageEndFrameOfPresent,
                                let tempImageView = self.tempImageView
                            {
                                tempImageView.frame = endRect
                            }
                            toView.alpha = 1
                            
                        } else {
                            if let photoBrowserVC = fromVC as? PhotosBrowserViewController,
                                let endRect = photoBrowserVC.imageEndFrameOfDismiss,
                                let tempImageView = self.tempImageView
                            {
                                tempImageView.frame = endRect
                            }
                            fromView.alpha = 0
                        }
        }) { (_) in
            
            if presenting {
                if let photoBrowserVC = toVC as? PhotosBrowserViewController,
                    let imageView = photoBrowserVC.currentImageView
                {
                    imageView.isHidden = false
                    self.tempImageView?.removeFromSuperview()
                    self.tempImageView = nil
                }
            }
            
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        }
    }
}
