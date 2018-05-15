//
//  ContinuousPresentedViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/9.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class ContinuousPresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0,
                                       green: CGFloat(arc4random_uniform(256))/255.0,
                                       blue: CGFloat(arc4random_uniform(256))/255.0,
                                       alpha: 1)
        
        
        let presentButton = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 100))
        presentButton.backgroundColor = .cyan
        presentButton.setTitle("present", for: .normal)
        presentButton.addTarget(self, action: #selector(tapPresent), for: .touchUpInside)
        view.addSubview(presentButton)
        
        
        let postNotificationDismissButton = UIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 100))
        postNotificationDismissButton.backgroundColor = .cyan
        postNotificationDismissButton.setTitle("post notification dismiss", for: .normal)
        postNotificationDismissButton.addTarget(self, action: #selector(tapPostNotificationDismiss), for: .touchUpInside)
        view.addSubview(postNotificationDismissButton)
        
    }

    @objc func tapPresent() {
        let vc = ContinuousPresentedViewController()
        self.present(vc, animated: true, completion: nil)
    }

    @objc func tapPostNotificationDismiss() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationDismiss), object: nil)
    }
    
    deinit {
        print("\(self) deinit")
    }
}
