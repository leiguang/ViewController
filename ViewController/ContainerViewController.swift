//
//  ContainerViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/7.
//  Copyright © 2018年 leiguang. All rights reserved.
//

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
