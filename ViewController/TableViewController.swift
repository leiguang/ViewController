//
//  TableViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/7.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let datas: [(title: String, className: String)] = [
        ("容器视图", "ContainerViewController"),
        ("在子视图控制器之间切换", "TransitionChildsViewController"),
        ("present模态跳转", "PresentingViewController"),
        ("连续present多个viewController", "ContinuousPresentingViewController"),
        ("自定义转场过渡动画", "TransitionAnimationsViewController"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "View Controller"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 在Swift中，由字符串转为类型的时候，如果类型是自定义的，需要在类型字符串前边加上你的项目的名字！
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let vcClass = NSClassFromString(appName + "." + datas[indexPath.row].className) as! UIViewController.Type
        let vc = vcClass.init()
        vc.title = datas[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Using segue dismiss
    // 详见“SeguesViewController.swift” 
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        print(#function)
    }
    
}
