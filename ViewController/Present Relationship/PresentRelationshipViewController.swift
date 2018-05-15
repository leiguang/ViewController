//
//  PresentRelationshipViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/11.
//  Copyright © 2018年 leiguang. All rights reserved.
//

/**
 
 [Overview] -> [The View Controller Hierarchy] -> [Presented View Controllers]

 When you present a view controller, UIKit looks for a view controller that provides a suitable context for the presentation. In many cases, UIKit chooses the nearest container view controller but it might also choose the window’s root view controller. In some cases, you can also tell UIKit which view controller defines the presentation context and should handle the presentation.
 
 */

import UIKit

class PresentRelationshipViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Present", style: .plain, target: self, action: #selector(tapPresent))
    }
    
    @objc func tapPresent() {
        let vc = PresentedViewController()
        self.present(vc, animated: true) {
            
            // 通过打印的地址，观察 “self”, "self.navigationController", “self.presentedViewController”, “self.presentingViewController” 之间的关系
            // 注意，vc的presentingViewController为 self.navigationController（即它的容器视图控制器）。！!
            // 解释：一般情况下，会选择离它最近的容器视图控制器来present它。当前self的容器视图是navigationController，所以vc的presentingViewController为 self.navigationController。       > [When you present a view controller, UIKit looks for a view controller that provides a suitable context for the presentation. In many cases, UIKit chooses the nearest container view controller but it might also choose the window’s root view controller. In some cases, you can also tell UIKit which view controller defines the presentation context and should handle the presentation.]
            
            print("**********")
            print(self)
            print(String(describing: self.navigationController))
            print(String(describing: self.presentedViewController))
            print(String(describing: self.navigationController?.presentedViewController))
            print(String(describing: self.presentedViewController?.presentingViewController))
            print("**********")
        }
    }

}
