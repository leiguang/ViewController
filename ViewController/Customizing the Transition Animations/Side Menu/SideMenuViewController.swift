//
//  SideMenuViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

/// 侧边栏的宽度
fileprivate var kSideMenuWidth: CGFloat { return ceil(UIScreen.main.bounds.width * 0.8) }
/// present时，x轴滑动偏移多少，触发present (带方向，单位pt)
fileprivate let kPanPresentSideMenuOffsetX: CGFloat = 100
/// dismiss时，x轴滑动偏移多少，触发dismiss (带方向，单位pt)
fileprivate let kPanDismissSideMenuOffsetX: CGFloat = -100
/// present时，x轴滑动速度达到多少，触发present (带方向，单位pt/s)
fileprivate let kPanPresentSideMenuVelocityX: CGFloat = 800
/// dismiss时，x轴滑动速度达到多少，触发dismiss (带方向，单位pt/s)
fileprivate let kPanDismissSideMenuVelocityX: CGFloat = -800


class SideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        print("\(self) deinit")
    }
}


class SideMenuTransitioning: NSObject, UIViewControllerTransitioningDelegate {
    
    lazy var animator = SideMenuAnimator()
    lazy var interactiveTransitioning = SideMenuDrivenInteractiveTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

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
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
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
}

class SideMenuDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    private var contextData: UIViewControllerContextTransitioning?
    private var containerView: UIView?
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        // Save the transition context for future reference.
        self.contextData = transitionContext
        
        let panDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(panDismissSideMenuViewController))
        panDismissGesture.maximumNumberOfTouches = 1
        
        self.containerView = transitionContext.containerView
        self.containerView?.addGestureRecognizer(panDismissGesture)
    }
    
    func panPresentSideMenuViewController(_ pan: UIPanGestureRecognizer, inView: UIView) {
        let offsetX = pan.translation(in: inView).x
        let velocityX = pan.velocity(in: inView).x
        
        print(offsetX)
        
        switch pan.state {
        case .possible:
            break
        case .began:
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
        case .cancelled, .failed:
            self.cancel()
        }
    }
    
    @objc private func panDismissSideMenuViewController(_ pan: UIPanGestureRecognizer) {
        guard let containerView = self.containerView, let fromVC = self.contextData?.viewController(forKey: .from) else {
            self.cancel()
            return
        }
        
        let offsetX = pan.translation(in: containerView).x
        let velocityX = pan.velocity(in: containerView).x
        
        print(offsetX)
        
        switch pan.state {
        case .possible:
            break
        case .began:
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
            containerView.removeGestureRecognizer(pan)
        case .cancelled, .failed:
            self.cancel()
            containerView.removeGestureRecognizer(pan)
        }
    }
}

class SideMenuPresentationController: UIPresentationController {
    
    private let dimmingView: UIView
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.dimmingView = UIView()
//        self.dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        dimmingView.backgroundColor = .red
        self.dimmingView.alpha = 0.0
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDimmingView))
        self.dimmingView.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    @objc private func tapDimmingView(_ gesture: UITapGestureRecognizer) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
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
            self.dimmingView.alpha = 0
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
}
