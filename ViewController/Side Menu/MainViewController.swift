//
//  MainViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/20.
//  Copyright © 2018年 leiguang. All rights reserved.
//

/**
 Notes:
    如果主页有ScrollView导致侧滑手势被屏蔽，可以为两个手势添加依赖来解决
 （例如：self.scrollView.panGestureRecognizer.require(toFail: self.sideMenuTransitioning.interactiveTransition.presentGesture)）
 */

import UIKit

class MainViewController: SideMenuMainBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // solve the conflict between sideMenuGesture and scrollView.panGesture
        // create a dependency relationship between scrollView.panGestureRecognizer and presentGesture.
        self.scrollView.panGestureRecognizer.require(toFail: self.sideMenuTransitioning.interactiveTransition.presentGesture)
    }

    @IBAction func presentSideMenuViewController(_ sender: Any) {
        present(menuViewController, animated: true, completion: nil)
    }

}
