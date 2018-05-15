//
//  PresentingViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/8.
//  Copyright © 2018年 leiguang. All rights reserved.
//

// [Presentations and Transitions] -> [Presenting a View Controller]

/**
 NOTE:
 When presenting a view controller using the UIModalPresentationFullScreen style, UIKit normally removes the views of the underlying view controller after the transition animations finish. You can prevent the removal of those views by specifying the UIModalPresentationOverFullScreen style instead. You might use that style when the presented view controller has transparent areas that let underlying content show through.
 */

import UIKit

class PresentingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UIModalPresentationStyle (其它样式文档中有图例说明)
        
        // 1.
        let fullScreen = UIButton(frame: CGRect(x: 100, y: 100, width: 150, height: 50))
        fullScreen.backgroundColor = .cyan
        fullScreen.setTitle("overFullScreen", for: .normal)
        fullScreen.addTarget(self, action: #selector(tapFullScreen), for: .touchUpInside)
        view.addSubview(fullScreen)
        // 2.
        let overFullScreen = UIButton(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        overFullScreen.backgroundColor = .cyan
        overFullScreen.setTitle("overFullScreen", for: .normal)
        overFullScreen.addTarget(self, action: #selector(tapOverFullScreen), for: .touchUpInside)
        view.addSubview(overFullScreen)
        // 3.
        let popover = UIButton(frame: CGRect(x: 100, y: 300, width: 150, height: 50))
        popover.backgroundColor = .cyan
        popover.setTitle("popover", for: .normal)
        popover.addTarget(self, action: #selector(tapPopover), for: .touchUpInside)
        view.addSubview(popover)
        
        
        // UIModalTransitionStyle
        
        // a.
        let coverVertical = UIButton(frame: CGRect(x: 100, y: 400, width: 150, height: 50))
        coverVertical.backgroundColor = .blue
        coverVertical.setTitle("coverVertical", for: .normal)
        coverVertical.addTarget(self, action: #selector(tapCoverVertical), for: .touchUpInside)
        view.addSubview(coverVertical)
        // b.
        let flipHorizontal = UIButton(frame: CGRect(x: 100, y: 500, width: 150, height: 50))
        flipHorizontal.backgroundColor = .blue
        flipHorizontal.setTitle("flipHorizontal", for: .normal)
        flipHorizontal.addTarget(self, action: #selector(tapFlipHorizontal), for: .touchUpInside)
        view.addSubview(flipHorizontal)
        // c.
        let crossDissolve = UIButton(frame: CGRect(x: 100, y: 600, width: 150, height: 50))
        crossDissolve.backgroundColor = .blue
        crossDissolve.setTitle("crossDissolve", for: .normal)
        crossDissolve.addTarget(self, action: #selector(tapCrossDissolve), for: .touchUpInside)
        view.addSubview(crossDissolve)
        // d.
        let partialCurl = UIButton(frame: CGRect(x: 100, y: 700, width: 150, height: 50))
        partialCurl.backgroundColor = .blue
        partialCurl.setTitle("partialCurl", for: .normal)
        partialCurl.addTarget(self, action: #selector(tapPartialCurl), for: .touchUpInside)
        view.addSubview(partialCurl)
        
    }

    
    // MARK: - UIModalPresentationStyle
    
    // 1. “fullScreen”, 即默认模式
    /**
     NOTE:
     When presenting a view controller using the UIModalPresentationFullScreen style, UIKit normally removes the views of the underlying view controller after the transition animations finish. You can prevent the removal of those views by specifying the UIModalPresentationOverFullScreen style instead. You might use that style when the presented view controller has transparent areas that let underlying content show through.
     
     观察 “1.” 和 “2.” 的不同
     */
    @objc func tapFullScreen() {
        let vc = PresentedViewController()
        vc.view.alpha = 0.5
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    // 2. 在 "overFullScreen" 样式下，
    // The views beneath the presented content are not removed from the view hierarchy when the presentation finishes. So if the presented view controller does not fill the screen with opaque content, the underlying content shows through.
    @objc func tapOverFullScreen() {
        let vc = PresentedViewController()
        vc.view.alpha = 0.5
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    
    
    // 3. "popover"
    // 在horizontally regular环境下可看到popover效果；
    // 在horizontally compact环境下，自动采用了"overFullScreen"方式呈现。
    // The UIModalPresentationPopover style displays the view controller in a popover view. Popovers are useful for displaying additional information or a list of items related to a focused or selected object. In a horizontally regular environment, the popover view covers only part of the screen, as shown in Figure 8-2. In a horizontally compact environment, popovers adapt to the UIModalPresentationOverFullScreen presentation style by default. A tap outside the popover view dismiss the popover automatically.
    @objc func tapPopover(_ sender: UIButton) {
        let vc = PresentedViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        vc.popoverPresentationController?.sourceView = sender
        vc.popoverPresentationController?.sourceRect = sender.frame
//        vc.popoverPresentationController?.permittedArrowDirections = [.up, .down]      // 允许的箭头方向
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - UIModalTransitionStyle
    
    // a.
    @objc func tapCoverVertical() {
        let vc = PresentedViewController()
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    // b.
    @objc func tapFlipHorizontal() {
        let vc = PresentedViewController()
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    // c.
    @objc func tapCrossDissolve() {
        let vc = PresentedViewController()
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    // d.
    @objc func tapPartialCurl() {
        let vc = PresentedViewController()
        vc.modalTransitionStyle = .partialCurl
        self.present(vc, animated: true, completion: nil)
    }
}
