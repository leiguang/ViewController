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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panPresentSideMenuViewController))
        edgeGesture.edges = .left
        self.view.addGestureRecognizer(edgeGesture)
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    @IBAction func presentSideMenuViewController(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController else { return }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.sideMenuTransitioning
        self.present(vc, animated: true, completion: nil)
        
//        if case edgeGesture.state = UIGestureRecognizerState.possible {
//            self.sideMenuTransitioning.interactiveTransitioning.update(1)
//            self.sideMenuTransitioning.interactiveTransitioning.finish()
//        }
    }
    
    @objc func panPresentSideMenuViewController(_ pan: UIScreenEdgePanGestureRecognizer) {
        if case .began = pan.state {
            self.presentSideMenuViewController(UIButton())
        }
        
        self.sideMenuTransitioning.interactiveTransitioning.panPresentSideMenuViewController(pan, inView: self.view)
        
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

