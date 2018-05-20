//
//  MainViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/20.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class MainViewController: SideMenuMainBaseViewController {
    
    /// 自定义导航栏视图
    lazy var naviView: UIView = {
       let v = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNaviHeight))
        v.image = NavigationBackgroundImage
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "image"), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print(#function)
        self.navigationController?.navigationBar.setBackgroundImage(NavigationBackgroundImage, for: .default)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    func setupNaviView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
//        self.navigationItem.leftBarButtonItem = nil     // 隐藏返回按钮
        self.view.addSubview(naviView)
    }

    @IBAction func presentSideMenuViewController(_ sender: Any) {
        present(menuViewController, animated: true, completion: nil)
    }

}
