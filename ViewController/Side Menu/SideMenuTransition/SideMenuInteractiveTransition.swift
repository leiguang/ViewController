//
//  SideMenuInteractiveTransition.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    // 是否执行交互动画 (不执行交互动画时(直接present)，需要在“func interactionControllerForPresentation(..)”中返回nil。 在ios11上，不写这个也会正常执行，但是iOS10上就会出现很奇怪的问题)
    var isInteracting = false
    
    private weak var presentedVC: UIViewController?
    private weak var presentingVC: UIViewController?
    
    /// 滑动present手势 作用的view
    private weak var viewOfPressentGesture: UIView?
    /// 滑动dismiss手势 作用的view
    private weak var viewOfDismissGesture: UIView?
    
    // 暴露出来，提供给外部来解决手势冲突
    lazy var presentGesture: UIPanGestureRecognizer = {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panToPresent))
        pan.edges = .left
        return pan
    }()
    
    lazy var dismissGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panToDismiss))
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    
    func addPresentGestureInView(_ inView: UIView, presentingVC: UIViewController, presentedVC: UIViewController) {
        if (self.viewOfPressentGesture == nil) ||
            (self.viewOfPressentGesture != nil && self.viewOfPressentGesture!.gestureRecognizers != nil && !self.viewOfPressentGesture!.gestureRecognizers!.contains(presentGesture))
        {
            inView.addGestureRecognizer(presentGesture)
            self.viewOfPressentGesture = inView
            self.presentingVC = presentingVC
            self.presentedVC = presentedVC
        }
    }
    
    func addDismissGestureInView(_ inView: UIView) {
        if (inView.gestureRecognizers == nil) ||
            (inView.gestureRecognizers != nil && !inView.gestureRecognizers!.contains(dismissGesture))
        {
            inView.addGestureRecognizer(dismissGesture)
            self.viewOfDismissGesture = inView
        }
    }
    
    @objc func panToPresent(_ pan: UIPanGestureRecognizer) {
        guard let inView = self.viewOfPressentGesture, let presentingVC = self.presentingVC, let presentedVC = self.presentedVC else { return }
        let offsetX = pan.translation(in: inView).x
        let velocityX = pan.velocity(in: inView).x
        
        switch pan.state {
        case .possible:
            break
        case .began:
            self.isInteracting = true
            pan.setTranslation(.zero, in: inView)
            presentingVC.present(presentedVC, animated: true, completion: nil)
        case .changed:
            if offsetX > 0 {
                let percentage = fabs(offsetX / kSideMenuWidth)
                self.update(percentage > 1 ? 1 : percentage)
            } else {
                self.update(0)
            }
        case .ended:
            self.isInteracting = false
            if offsetX > kPanPresentSideMenuOffsetX || velocityX > kPanPresentSideMenuVelocityX {
                self.finish()
            } else {
                self.cancel()
            }
        case .cancelled, .failed:
            self.isInteracting = false
            self.cancel()
        }
    }
    
    @objc private func panToDismiss(_ pan: UIPanGestureRecognizer) {
        guard let presentVC = self.presentedVC, let containerView = self.viewOfDismissGesture else {
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
            presentVC.dismiss(animated: true, completion: nil)
        case .changed:
            if offsetX < 0 {
                let percentage = fabs(offsetX / kSideMenuWidth)
                self.update(percentage > 1 ? 1 : percentage)
            } else {
                self.update(0.0)
            }
        case .ended:
            self.isInteracting = false
            if offsetX < kPanDismissSideMenuOffsetX || velocityX < kPanDismissSideMenuVelocityX {
                self.finish()
            } else {
                self.cancel()
            }
        case .cancelled, .failed:
            self.isInteracting = false
            self.cancel()
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
}


