//
//  PresentedViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/8.
//  Copyright © 2018年 leiguang. All rights reserved.
//


import UIKit

class PresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green

        let dismissButton = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 100))
        dismissButton.backgroundColor = .red
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        self.view.addSubview(dismissButton)
    }

    @objc func tapDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
