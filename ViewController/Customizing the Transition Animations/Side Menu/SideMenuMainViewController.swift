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
        
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panPresentSideMenuViewController))
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
    
    @objc func panPresentSideMenuViewController(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        self.sideMenuTransitioning.interactiveTransitioning.panPresentSideMenuViewController(pan, inView: self.view)
        
        if case .began = pan.state {
            self.present(menuViewController, animated: true, completion: nil)
        }
        
//        let offsetX = pan.translation(in: self.view).x
//
//        print(pan.velocity(in: self.view))
//
//        switch pan.state {
//        case .possible:
//            break
//        case .began:
//            pan.setTranslation(.zero, in: self.view)
//            self.presentSideMenuViewController(UIButton())
//        case .changed:
//            if offsetX > 0 {
//                let percentage = fabs(offsetX / view.bounds.height)
//                self.sideMenuTransitioning.interactiveTransitioning.update(percentage)
//            } else {
//                self.sideMenuTransitioning.interactiveTransitioning.update(0)
//            }
//        case .ended:
//            if offsetX > 100 {
//                self.sideMenuTransitioning.interactiveTransitioning.finish()
//            } else {
//                self.sideMenuTransitioning.interactiveTransitioning.cancel()
//            }
//        case .cancelled, .failed:
//            self.sideMenuTransitioning.interactiveTransitioning.cancel()
//        }
    }
}

