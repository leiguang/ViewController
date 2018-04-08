//
//  PresentedViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/8.
//  Copyright © 2018年 leiguang. All rights reserved.
//

/**
 
 对于方法 “func dismiss(animated flag: Bool, completion: (() -> Void)? = nil)” 的描述，
 
 注意点:   "presenting view controller（呈现视图控制器）" 负责 dismiss 被其呈现的试图控制器。如果您在“presented view controller（被呈现的视图控制器）“身上调用此方法，UIKit会要求呈现视图控制器来处理解除。
          如果您连续呈现多个视图控制器，从而构建一叠呈现的视图控制器，则在视图控制器上的较低视图控制器上调用此dismiss方法 将dismiss其直接的子视图控制器以及堆栈上该子视图上的所有视图控制器。发生这种情况时，只有最上面的视图才会以动画形式被解散;任何中间视图控制器都会简单地从堆栈中移除。最顶层的视图使用其模式转换样式被解散，这可能与堆栈中较低视图控制器使用的样式不同。
 
 The presenting view controller is responsible for dismissing the view controller it presented. If you call this method on the presented view controller itself, UIKit asks the presenting view controller to handle the dismissal.
 
 If you present several view controllers in succession, thus building a stack of presented view controllers, calling this method on a view controller lower in the stack dismisses its immediate child view controller and all view controllers above that child on the stack. When this happens, only the top-most view is dismissed in an animated fashion; any intermediate view controllers are simply removed from the stack. The top-most view is dismissed using its modal transition style, which may differ from the styles used by other view controllers lower in the stack.
 
 If you want to retain a reference to the view controller's presented view controller, get the value in the presentedViewController property before calling this method.
 
 The completion handler is called after the viewDidDisappear(_:) method is called on the presented view controller.
 
 */


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
