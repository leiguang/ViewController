//
//  SeguesViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/4/8.
//  Copyright © 2018年 leiguang. All rights reserved.
//

// [Presentations and Transitions] -> [Using Segues]

/**
 
 Creating an Unwind Segue
 
 Unwind segues let you dismiss view controllers that have been presented. You create unwind segues in Interface Builder by linking a button or other suitable object to the Exit object of the current view controller. When the user taps the button or interacts with the appropriate object, UIKit searches the view controller hierarchy for an object capable of handling the unwind segue. It then dismisses the current view controller and any intermediate view controllers to reveal the target of the unwind segue.
 
 To create an unwind segue:
 1. Choose the view controller that should appear onscreen at the end of an unwind segue.
 2. Define an unwind action method on the view controller you chose.
    The Swift syntax for this method is as follows:
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue)
 
 3. Navigate to the view controller that initiates the unwind action.
 4. Control-click the button (or other object) that should initiate the unwind segue. This element should be in the view controller you want to dismiss.
 5. Drag to the Exit object at the top of the view controller scene.image: ../Art/segue_unwind_linking_2x.png
 6. Select your unwind action method from the relationship panel.
 
 */

import UIKit

class SeguesViewController: UIViewController {
    
/**
     
     ！！！！！！！  注意  ！！！！！！！！
     

     我也是醉了！！！ 这个"@IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue)"方法竟不是写在 “dismiss”按钮所在的ViewController中，而应该写在 dismiss结束后所呈现的ViewController中，再仔细看文档所述：
     “1. Choose the view controller that should appear onscreen at the end of an unwind segue.
     2. Define an unwind action method on the view controller you chose.”
     
     写在 "the end of an unwind segue" 所在的ViewController中。 因此本例需要写在“SeguesViewController”中。 否则写错地方一脸懵逼。
     
     
     @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        print(#function)
     }
 
 */
    
    
    // MARK: - Using segue dismiss
    // 详见“SeguesViewController.swift”
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        print(#function)
    }
  
}
