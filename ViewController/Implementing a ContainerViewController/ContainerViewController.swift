//
//  ContainerViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/7.
//  Copyright © 2018年 leiguang. All rights reserved.
//

/**
 
 [Overview] -> [The View Controller Hierarchy]
 
 When container view controllers are involved, UIKit may modify the presentation chain to simplify the code you have to write. Different presentation styles have different rules for how they appear onscreen—for example, a full-screen presentation always covers the entire screen. When you present a view controller, UIKit looks for a view controller that provides a suitable context for the presentation. In many cases, UIKit chooses the nearest container view controller but it might also choose the window’s root view controller. In some cases, you can also tell UIKit which view controller defines the presentation context and should handle the presentation.
 
 Figure 2-4 shows why containers usually provide the context for a presentation. When performing a full-screen presentation, the new view controller needs to cover the entire screen. Rather than requiring the child to know the bounds of its container, the container decides whether to handle the presentation. Because the navigation controller in the example covers the entire screen, it acts as the presenting view controller and initiates the presentation.
 
 */



// [View Controller Definition] -> [Implementing a Container View Controller]


/**
 
 为了实现一个容器视图控制器，UIKit的唯一要求是您需要在容器视图控制器和任何子视图控制器之间建立正式的父子关系，父子关系确保子视图控制器收到系统相关的消息。
 The only requirement from UIKit is that you establish a formal parent-child relationship between the container view controller and any child view controllers. The parent-child relationship ensures that the children receive any relevant system messages.
 
 */

/**
 
 Adding a Child View Controller to Your Content
 
 To incorporate a child view controller into your content programmatically, create a parent-child relationship between the relevant view controllers by doing the following:
 
 Call the addChildViewController: method of your container view controller.
 This method tells UIKit that your container view controller is now managing the view of the child view controller.
 Add the child’s root view to your container’s view hierarchy.
 Always remember to set the size and position of the child’s frame as part of this process.
 Add any constraints for managing the size and position of the child’s root view.
 Call the didMoveToParentViewController: method of the child view controller.
 
 */

/**
 
 Removing a Child View Controller
 
 To remove a child view controller from your content, remove the parent-child relationship between the view controllers by doing the following:
 
 Call the child’s willMoveToParentViewController: method with the value nil.
 Remove any constraints that you configured with the child’s root view.
 Remove the child’s root view from your container’s view hierarchy.
 Call the child’s removeFromParentViewController method to finalize the end of the parent-child relationship.
 
 */

import UIKit

class ContainerViewController: UIViewController {
    
    let child = ChildViewController1()
    
    override func loadView() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .white
        label.text = "Container view controller"
        self.view = label
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAChildViewController))
        
        let remove = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeAChildViewController))
        
        self.navigationItem.rightBarButtonItems = [add, remove].reversed()
    
    }
    
    @objc func addAChildViewController() {
        self.addChildViewController(child)
        child.view.frame = view.bounds
        self.view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }

    @objc func removeAChildViewController() {
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
    }
    
}


