//
//  MainViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/20.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class MainViewController: SideMenuMainBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func presentSideMenuViewController(_ sender: Any) {
        present(menuViewController, animated: true, completion: nil)
    }

}
