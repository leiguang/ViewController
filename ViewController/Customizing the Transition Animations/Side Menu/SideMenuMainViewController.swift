//
//  SideMenuMainViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/16.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class SideMenuMainViewController: UIViewController, SideMenuDelegate {

    let sideMenuTransitioning = SideMenuTransitioning()
    
    var edgeGesture: UIScreenEdgePanGestureRecognizer!
    
    var menuViewController: SideMenuViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        addPanGestureOfPresent()
        
        
        menuViewController = storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self.sideMenuTransitioning
        menuViewController.delegate = self
    }
   
    deinit {
        print("\(self) deinit")
    }
    
    @IBAction func push(_ sender: Any) {
        let vc = SideMenuDetailViewController()
        vc.title = "Push"
        show(vc, sender: nil)
    }
    
    
    @IBAction func presentSideMenuViewController(_ sender: Any) {
        
        self.present(menuViewController, animated: true, completion: nil)
        
    }
    
    @objc func panToPresent(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        self.sideMenuTransitioning.interactiveTransition.panToPresent(presenting: self, presented: menuViewController, pan: pan)

    }
    
    // MARK: - SideMenuDelegate
    func push(_ vc: UIViewController) {
        self.show(vc, sender: nil)
    }
    
    func wirePanToDismissGestureInView(_ view: UIView) {
        
    }
    
    //
    func addPanGestureOfPresent() {
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panToPresent))
        edgeGesture.edges = .left
        self.view.addGestureRecognizer(edgeGesture)
    }
}

