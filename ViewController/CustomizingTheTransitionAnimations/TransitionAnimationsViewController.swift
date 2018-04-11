//
//  TransitionAnimationsViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/10.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class TransitionAnimationsViewController: UIViewController {

    let myTransitioningDelegate = MyTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "transition", style: .plain, target: self, action: #selector(tapTransition))
    }

    @objc func tapTransition() {
        let vc = PresentedViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.myTransitioningDelegate
        self.present(vc, animated: true) {
            print("\(#function) completion.")
        }
    }

}

class MyTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyAnimator(presenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyAnimator(presenting: false)
    }
}

class MyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get the set of relevant objects.
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = fromVC.view,
            let toView = toVC.view else {
                
                fatalError("\(#file) -> \(#function) 无法找到 fromeVC或toVC")
        }
     
        
        /**
         
         文档中下面这部分代码应该是有问题，因为：
             经试验：
             1. 当present时，通过“transitionContext.view(forKey: .from)”方法获取到的“fromView”为nil；
             2. 当dismiss时，通过“transitionContext.view(forKey: .to)”方法获取到的“toView”为nil。
         所以通过下面方法获取到的toView为nil时，“toView”无法添加到“containerView”上。
         但是，不论“present”或“dismiss”情形下，通过“transitionContext.viewController(forKey: ...)都是可以获取到“fromVC”和“toVC”的，并且通过 "fromVC.view"和”toVC.view“ 也能获取到view(不为nil)，因此我觉得可以通过vc.view来获取对应view，然后再添加到containerView上。（仍有待查阅考证）
         
         
         //            let toView = transitionContext.view(forKey: .to)
         //            let fromView = transitionContext.view(forKey: .from)
         
         // Always add the "to" view to the container.
         // And it doesn't hurt to set its start frame.
         containerView.addSubview(toView)
         toView.frame = toViewStartFrame
         
         */


        
        
        // Set up some variables for the animation.
        let containerFrame = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)      // 文档中这部分真的坑，dismiss时这个值为空
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        
        // Set up the animation parameters.
        if self.presenting {
            // Modify the frame of the presented view so that it starts offscreen at the lower-right corner of the container.
            toViewStartFrame.origin.x = containerFrame.size.width
            toViewStartFrame.origin.y = containerFrame.size.height
            
        } else {
            // Modify the frame of the dismissed view so it ends in the lower-right corner of the container view.
            fromViewFinalFrame = CGRect(x: containerFrame.size.width, y: containerFrame.size.height, width: toView.frame.size.width, height: toView.frame.size.height)
        }
        
        
        // Always add the "to" view to the container.
        // And it doesn't hurt to set its start frame.
        containerView.addSubview(toView)
        
        if self.presenting {
            toView.frame = toViewStartFrame
        } else {
            toView.frame = containerFrame
        }
        
        
        
        // Animate using the animator's own duration value.
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            if self.presenting {
                // Move the presented view into position.
                toView.frame = toViewFinalFrame
                
            } else {
                // Move the dimissed view offscreen.
                fromView.frame = fromViewFinalFrame
            }
            
        }) { (finished) in
            
            let success = !transitionContext.transitionWasCancelled
            
            // After a failed presentation or successful dismissal, remove the view.
            if (self.presenting && !success) || (!self.presenting && success) {
                toView.removeFromSuperview()
            }
            
            // Notify UIKit that the transition has finished
            transitionContext.completeTransition(success)
        }
        
    }

//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        <#code#>
//    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("\(#function), transitionCompleted: \(transitionCompleted).")
    }
}
