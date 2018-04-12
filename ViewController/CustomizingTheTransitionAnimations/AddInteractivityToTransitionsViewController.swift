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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "transition", style: .plain, target: self, action: #selector(tapTransition))
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: view.bounds.width-20, height: 100))
        label.text = "点击“transition”后，单指按住屏幕向下滑动，实现dismiss手势交互效果。"
        label.numberOfLines = 0
        self.view.addSubview(label)
    }
    
    @objc func tapTransition() {
        let vc = PresentedViewController()
        vc.transitioningDelegate = self.myTransitioning
        self.present(vc, animated: true) {
            print("\(#function) completion.")
        }
    }
}

fileprivate class MyTransitioning: NSObject, UIViewControllerTransitioningDelegate {

    private lazy var animator = MyAnimator()
    private lazy var interactiveTransitioning = MyPercentDrivenInteractiveTransition()
    
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
            
            // 竖直方向上偏移量超过100则 finish完成dismiss，否则cancel恢复dismiss之前的状态
            // (注意：由于 默认的过渡动画是easeInOut的，所以手指的translation.y偏移量和 所看到的view.y的实际偏移量有所不同，以手指的偏移量为准来计算。)
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
