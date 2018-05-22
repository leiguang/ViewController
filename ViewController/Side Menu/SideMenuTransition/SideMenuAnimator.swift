//
//  SideMenuAnimator.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

/**
 注意，这里处理视图层级 presentingSuperview部分的代码非常关键！！！  （如果没有这段，在iOS11上是正常的，但是在iOS10上presenting视图控制器 却无法跟随手势动画）

 UIPresentationController类的作用可参考前面 iOS 8 的改进：UIPresentationController 一节。注意，UIPresentationController参与转场并没有改变 presentingView 与 containerView 的层次关系，能够修复这个问题我猜测是重写的该方法返回true后交互转场控制同时对这两个视图进行了控制而非对两者的父系视图进行控制，因为这个方法返回false时不起作用。
 
 那 iOS 8 以下的系统怎么办？最好的办法是转场时不要对 presentingView 添加动画，不是开玩笑，我觉得 Modal 转场的视觉风格在 presentingView 上添加动画没有什么必要，不过，真要这样做还是得解决不是。在 Modal 转场的差异里我尝试了在 Custom 模式来下模拟 FullScreen 模式，就是在动画控制器里用变量维护 presentingView 的父视图，剩下的部分和通用的动画控制器没有区别，将 presentingView 加入到 containerView，只是在转场结束后将 presentingView 恢复到原来的视图结构里。这样，交互控制就能控制 presentingView 上的动画了。如果你要在 Custom 模式下第三方的动画控制器，这些动画控制器都需要调整，代价不小。
 
【 参考自：https://github.com/seedante/iOS-Note/wiki/View-Controller-Transition-PartII#Chapter3.7】
 
 */

/**
 注意： dismiss的手势动画在iOS 11上，刚开始触摸时会闪动，日了狗了。 终于找到如下解决办法，在UIView.animate(...)中设置一个简短的delay
 
 // HACK: If zero, the animation briefly flashes in iOS 11. UIViewPropertyAnimators (iOS 10+) may resolve this.
 
 > [SideMenu](https://github.com/jonkykong/SideMenu)
 */

import UIKit

class SideMenuAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var presentingSuperview: UIView?

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

        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        var toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        if presenting {
            fromViewFinalFrame.origin.x = kSideMenuWidth
            toViewStartFrame = CGRect(x: -kSideMenuWidth, y: 0, width: kSideMenuWidth, height: UIScreen.main.bounds.height)
            toViewFinalFrame = CGRect(x: 0, y: 0, width: kSideMenuWidth, height: UIScreen.main.bounds.height)
        } else {
            fromViewFinalFrame.origin.x = -kSideMenuWidth
            toViewFinalFrame.origin.x = 0
        }

        if presenting {
            // 这个非常关键，而由谁来维持这个父视图呢，看看动画控制器以及转场代理的关系就知道这是个很麻烦的事情。
            self.presentingSuperview = fromView.superview

            toView.frame = toViewStartFrame

            // 将 presentingView 加入到 containerView 下，这样 presentation 转场时也能控制 presentingView 上的动画
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
            containerView.sendSubview(toBack: fromView)
            containerView.bringSubview(toFront: toView)
        }
        
        // iOS 11上刚开始触摸时会闪动，日了狗了。终于找到如下解决办法，设置一个简短的delay
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0.05, // HACK: If zero, the animation briefly flashes in iOS 11. UIViewPropertyAnimators (iOS 10+) may resolve this. [参考自GitHub上的侧边栏库SideMenu]
                       options: [],
                       animations: {
            if presenting {
                fromView.frame = fromViewFinalFrame
                toView.frame = toViewFinalFrame
            } else {
                fromView.frame = fromViewFinalFrame
                toView.frame = toViewFinalFrame
            }
        }) { (_) in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)

            // 最后一步：恢复 presentingView 到原来的视图结构里。(如果是在 FullScreen 模式下，UIKit 会自动做这件事，可以省去这一步。)
            if presenting && cancelled {
                self.presentingSuperview?.addSubview(fromView)
            }
            if !presenting && !cancelled {
                self.presentingSuperview?.addSubview(toView)
            }
        }
    }

    deinit {
        print("\(self) deinit")
    }
}

