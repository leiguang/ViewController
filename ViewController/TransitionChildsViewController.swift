//
//  TransitionChildsViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/8.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class TransitionChildsViewController: UIViewController {

    let child = ChildViewController1()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transition", style: .plain, target: self, action: #selector(transitionBetweenChildViewControllers))
        
        addAChildViewController()
    }
    
    @objc func addAChildViewController() {
        self.addChildViewController(child)
        child.view.frame = view.bounds
        self.view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    // In this example, the transitionFromViewController:toViewController:duration:options:animations:completion: method automatically updates the container’s view hierarchy, so you do not need to add and remove the views yourself.
    @objc func transitionBetweenChildViewControllers() {
        
        // Prepare the two view controllers for the change.
        let oldVC = child
        let newVC = ChildViewController2()
        oldVC.willMove(toParentViewController: nil)
        self.addChildViewController(newVC)
        
        // Get the start frame of the new view controller and the end frame for the old view controller. Both rectangles are offscreen.
        newVC.view.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        let oldViewEndFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        
        // Queue up the transition animation.
        self.transition(from: oldVC, to: newVC, duration: 1, options: .curveLinear, animations: {

            // Animate the views to their final positions.
            newVC.view.frame = oldVC.view.frame
            oldVC.view.frame = oldViewEndFrame

        }) { (finished) in

            // Remove the old view controller and send the final notification to the new view controller.
            oldVC.removeFromParentViewController()
            newVC.didMove(toParentViewController: self)

        }
    }
}
