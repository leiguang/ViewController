//
//  TransitionAnimationsViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/10.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class TransitionAnimationsViewController: UIViewController {

    private let myTransitioning = MyTransitioning()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "transition", style: .plain, target: self, action: #selector(tapTransition))
    }

    @objc func tapTransition() {
        let vc = PresentedViewController()
        //        vc.modalPresentationStyle = .custom      // 特别注意: 只有使用自定义的“PresentationController”时，才需要设置“modalPresentationStyle = .custom”。  The presentation controller is used only when the view controller’s modalPresentationStyle property is set to UIModalPresentationCustom
        vc.transitioningDelegate = self.myTransitioning
        self.present(vc, animated: true) {
            print("\(#function) completion.")
        }
    }

}

fileprivate class MyTransitioning: NSObject, UIViewControllerTransitioningDelegate {

    private lazy var animator = MyAnimator()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return MyAnimator(presenting: true)
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return MyAnimator(presenting: false)
        return animator
    }
}

// Figure 10-5 shows a custom presentation and dismissal transition that animates its view diagonally. During a presentation, the presented view starts offscreen and animates diagonally up and to the left until it is visible. During a dismissal, the view reverses its direction and animates down and to the right until it is offscreen once again.
class MyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
//    let presenting: Bool
//
//    init(presenting: Bool) {
//        self.presenting = presenting
//        super.init()
//    }
    
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
         但是，不论“present”或“dismiss”情形下，通过“transitionContext.viewController(forKey: ...)都是可以获取到“fromVC”和“toVC”的，并且通过 "fromVC.view"和”toVC.view“ 也能获取到view(不为nil)，因此我觉得可以通过vc.view来获取对应view，然后再添加到containerView上。（虽然文档没说，但网上也看到很多这种做法，应该可行吧。 有待查证）
         
         
             let toView = transitionContext.view(forKey: .to)
             let fromView = transitionContext.view(forKey: .from)
         
         */


        
        // 在判断 "self.presenting" 时，网上有这种做法是：通过判断 “如果 fromVC.presentedViewController == toVC“ 或 ”toVC.presentingViewController == fromVC“，则是”presenting"。   这样在”MyTransitioningDelegate“中就只用创建一个”MyAnimator“对象了。
        let presenting = (fromVC.presentedViewController == toVC)
        
        // Set up some variables for the animation.
        let containerFrame = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)      // 文档中这部分真的坑，dismiss时这个值为空
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        
        
        // Set up the animation parameters.
        if presenting {
            // Modify the frame of the presented view so that it starts offscreen at the lower-right corner of the container.
            toViewStartFrame.origin.x = containerFrame.size.width
            toViewStartFrame.origin.y = containerFrame.size.height
            toViewStartFrame.size = containerFrame.size
        } else {
            // Modify the frame of the dismissed view so it ends in the lower-right corner of the container view.
            fromViewFinalFrame = CGRect(x: containerFrame.size.width, y: containerFrame.size.height, width: toView.frame.size.width, height: toView.frame.size.height)
        }
        
        
        // Always add the "to" view to the container.
        // And it doesn't hurt to set its start frame.
        if presenting {
            toView.frame = toViewStartFrame
            containerView.insertSubview(toView, aboveSubview: fromView)   // present时需要把toView放在fromView上面（可以按需交换位置）
        } else {
            toView.frame = containerFrame
            containerView.insertSubview(fromView, aboveSubview: toView)     // 需要手动把toView放到fromView下面，否则fromView在下面被挡住了看不见移出效果
        }
        
        
        // Animate using the animator's own duration value.
        // 注意：在做手势交互动画时，因为默认是".curveEaseInOut"，如果要使计算的手势偏移量和实际动画的偏移量相同，则需要在这儿把动画设置为匀速线性的“.curveLinear”类型。
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            
            if presenting {
                // Move the presented view into position.
                toView.frame = toViewFinalFrame
                
            } else {
                // Move the dimissed view offscreen.
                fromView.frame = fromViewFinalFrame
            }
            

        }) { (finished) in
            
            let cancelled = transitionContext.transitionWasCancelled
            
            // 文档中的这句示例代码 有问题(成功dismissal时不应该移除toView)
            // After a failed presentation or failed dismissal, remove the view. (可交互的时候会发生)
            // 注意：发现，在可交互的dismiss情境下，如果cancell，也不应该把"toView.removeFromview"，否则底部的toView就变成一片漆黑。
            if presenting && cancelled {
                toView.removeFromSuperview()
            }
            
            // Notify UIKit that the transition has finished
            transitionContext.completeTransition(!cancelled)
        }
        
    }

//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        <#code#>
//    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("\(#function), transitionCompleted: \(transitionCompleted).")
    }
}
