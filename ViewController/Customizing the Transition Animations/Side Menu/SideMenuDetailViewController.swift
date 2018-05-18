//
//  SideMenuDetailViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.count < 3 {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            } else {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
}
