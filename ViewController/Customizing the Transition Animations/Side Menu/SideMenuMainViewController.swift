//
//  SideMenuMainViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuMainViewController: UIViewController {

    let sideMenuTransitioning = SideMenuTransitioning()
    
    var edgeGesture: UIScreenEdgePanGestureRecognizer!
    
    var menuViewController: SideMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panToPresent))
        edgeGesture.edges = .left
        self.view.addGestureRecognizer(edgeGesture)
        
        menuViewController = storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self.sideMenuTransitioning
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    @IBAction func presentSideMenuViewController(_ sender: Any) {
        
        self.present(menuViewController, animated: true, completion: nil)
        
    }
    
    @objc func panToPresent(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        self.sideMenuTransitioning.interactiveTransition.panToPresent(presenting: self, presented: menuViewController, pan: pan)

    }
}

