//
//  AddInteractivityToTransitionsViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class AddInteractivityToTransitionsViewController: UIViewController {

    private let myTransitioning = MyTransitioning()
    
    var panUpGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "transition", style: .plain, target: self, action: #selector(tapTransition))
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: view.bounds.width-20, height: 300))
        label.text = "单指按住屏幕向上滑动，实现交互式present效果（超过150pt后松手即可完成present）；\n\n点击“transition”后，单指按住屏幕向下滑动，实现交互式dismiss效果（超过150pt后松手即可完成dismiss）。"
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        self.panUpGesture = UIPanGestureRecognizer(target: self, action: #selector(panUp))
        self.view.addGestureRecognizer(panUpGesture)
    }
    
    @objc func tapTransition() {
        let vc = PresentedViewController()
        vc.modalPresentationStyle = .custom     // MyPresentationController：时才用到
        vc.transitioningDelegate = self.myTransitioning
        self.present(vc, animated: true) { [weak self] in
            print("\(#function) completion.")
            guard let strongSelf = self else { return }
            strongSelf.view.addGestureRecognizer(strongSelf.panUpGesture)   // 最好等到dismiss完成后再加上，否则滑动太快乱滑的时候不准确
        }
    }
    
    @objc func panUp(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        print("panUp: \(translation)")
        
        if gesture.state == .began {
            gesture.setTranslation(.zero, in: self.view)
            self.tapTransition()
            
        } else if gesture.state == .changed {
            if translation.y < 0 {
                let percentage = fabs(translation.y / view.bounds.height)
                self.myTransitioning.interactiveTransitioning.update(percentage)
            } else {
                self.myTransitioning.interactiveTransitioning.update(0)
            }
            
        } else if gesture.state == .ended {
            if translation.y < -150 {
                self.myTransitioning.interactiveTransitioning.finish()
                self.view.removeGestureRecognizer(panUpGesture)     // finished时移除吧，这里是在present的completion回调中再加上的，最好是等到dismiss完成后再加上，否则乱滑操作太快的时候不准确
            } else {
                self.myTransitioning.interactiveTransitioning.cancel()
            }
            
        } else if gesture.state == .cancelled || gesture.state == .failed {
            self.myTransitioning.interactiveTransitioning.cancel()
        }
        
    }
}

fileprivate class MyTransitioning: NSObject, UIViewControllerTransitioningDelegate {

    lazy var animator = MyAnimator()
    lazy var interactiveTransitioning = MyPercentDrivenInteractiveTransition()
    
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


    // MyPresentationController：时用到
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

fileprivate class MyPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    private var contextData: UIViewControllerContextTransitioning?
    private var containerView: UIView?
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Always call super first.
        super.startInteractiveTransition(transitionContext)
        
        // Save the transition context for future reference.
        self.contextData = transitionContext
        
        // Create a pan gesture recognizer to monitor events.
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeUpdate))
        panGesture.maximumNumberOfTouches = 1
        
        // Add the gesture recognizer to the container view.
        self.containerView = transitionContext.containerView
        self.containerView?.addGestureRecognizer(panGesture)
    }
    
    @objc func handleSwipeUpdate(_ panGesture: UIPanGestureRecognizer) {
        guard let containerView = self.containerView,
            let fromVC = self.contextData?.viewController(forKey: .from) else {
            self.cancel()
            return
        }
        
        if panGesture.state == .began {
            
            panGesture.setTranslation(.zero, in: containerView)
            fromVC.dismiss(animated: true, completion: nil)
            
        } else if panGesture.state == .changed {
            // Get the current translation value.
            let translation = panGesture.translation(in: containerView)
            print("panDown: \(translation)")
            if translation.y > 0 {
                // Compute how far the gesture has travelled vertically, relative to the height of the container view.
                let percentage = fabs(translation.y / containerView.bounds.height)
                
                // Use the translation value to update the interactive animator.
                self.update(percentage)
                
            } else {
                self.update(0)
            }
            
            
        } else if panGesture.state == .ended {
            
            let translation = panGesture.translation(in: containerView)
            
            // 竖直方向上偏移量超过150则 finish完成dismiss，否则cancel恢复dismiss之前的状态
            // (注意：由于 默认的过渡动画是"curveEaseInOut"的，所以手指的translation.y偏移量和 所看到的view.y的实际偏移量有所不同，以手指的偏移量为准来计算。)   如果要使计算的手势偏移量和实际动画的偏移量相同，则需要在"class -> MyAnimator -> func animateTransition(...)中"把生成的过渡动画设置为匀速线性的“.curveLinear”类型。
            if translation.y >= 150 {
                // Finish the transition and remove the gesture recognizer.
                self.finish()
            } else {
                self.cancel()
            }
            
            containerView.removeGestureRecognizer(panGesture)
            
        } else if panGesture.state == .cancelled || panGesture.state == .failed {
            self.cancel()
            containerView.removeGestureRecognizer(panGesture)
        }
    }
}
