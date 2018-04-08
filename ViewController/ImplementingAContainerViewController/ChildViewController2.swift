//
//  ChildViewController2.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/7.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class ChildViewController2: UIViewController {

    override func loadView() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .green
        label.text = "Child view controller 2"
        self.view = label
    }

}
