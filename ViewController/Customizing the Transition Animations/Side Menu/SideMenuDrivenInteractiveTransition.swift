//
//  SideMenuDrivenInteractiveTransition.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    // 是否执行交互动画 (不执行交互动画时，需要在“func interactionControllerForPresentation(..)”中返回nil。 在ios11上，不写这个也会正常执行，但是iOS10上就会出现很奇怪的问题)
    var isInteracting = false
    
    private var contextData: UIViewControllerContextTransitioning?
    private var containerView: UIView?
    private var panDismissGesture: UIPanGestureRecognizer?
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        // Save the transition context for future reference.
        self.contextData = transitionContext
        
        if self.panDismissGesture == nil {
            self.panDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(panDismissSideMenuViewController))
            self.panDismissGesture!.maximumNumberOfTouches = 1
        }
        
//        self.panDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(panDismissSideMenuViewController))
//        self.panDismissGesture!.maximumNumberOfTouches = 1
        
        self.containerView = transitionContext.containerView
        self.containerView?.addGestureRecognizer(self.panDismissGesture!)
    }
    
    func panPresentSideMenuViewController(_ pan: UIPanGestureRecognizer, inView: UIView) {
        let offsetX = pan.translation(in: inView).x
        let velocityX = pan.velocity(in: inView).x

        switch pan.state {
        case .possible:
            break
        case .began:
            self.isInteracting = true 
            pan.setTranslation(.zero, in: inView)
        case .changed:
            if offsetX > 0 {
                let percentage = fabs(offsetX / inView.bounds.height)
                self.update(percentage)
            } else {
                self.update(0)
            }
        case .ended:
            if offsetX > kPanPresentSideMenuOffsetX || velocityX > kPanPresentSideMenuVelocityX {
                self.finish()
            } else {
                self.cancel()
            }
            self.isInteracting = false
        case .cancelled, .failed:
            self.cancel()
            self.isInteracting = false
        }
    }
    
    @objc private func panDismissSideMenuViewController(_ pan: UIPanGestureRecognizer) {
        guard let containerView = self.containerView, let fromVC = self.contextData?.viewController(forKey: .from) else {
            self.cancel()
            return
        }
        
        let offsetX = pan.translation(in: containerView).x
        let velocityX = pan.velocity(in: containerView).x
        
        switch pan.state {
        case .possible:
            break
        case .began:
            self.isInteracting = true
            pan.setTranslation(.zero, in: containerView)
            fromVC.dismiss(animated: true, completion: nil)
        case .changed:
            if offsetX < 0 {
                let percentage = fabs(offsetX / kSideMenuWidth)
                self.update(percentage)
            } else {
                self.update(0.0)
            }
        case .ended:
            if offsetX < kPanDismissSideMenuOffsetX || velocityX < kPanDismissSideMenuVelocityX {
                self.finish()
            } else {
                self.cancel()
            }
            self.isInteracting = false
        //            containerView.removeGestureRecognizer(pan)
        case .cancelled, .failed:
            self.cancel()
            self.isInteracting = false 
            //            containerView.removeGestureRecognizer(pan)
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


