//
//  PhotosBrowserViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/21.
//  Copyright © 2018年 leiguang. All rights reserved.
//

// [UIScrollView Tutorial](https://www.raywenderlich.com/159481/uiscrollview-tutorial-getting-started)
// [ImageScrollView](https://github.com/imanoupetit/ImageScrollView)
// [Zooming by Tapping](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/UIScrollView_pg/ZoomingByTouch/ZoomingByTouch.html#//apple_ref/doc/uid/TP40008179-CH4-SW1)
// [Zooming Programmatically](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/UIScrollView_pg/ZoomZoom/ZoomZoom.html#//apple_ref/doc/uid/TP40008179-CH102-SW7)

/**
 Displaying a Page Control Indicator
 For the final part of this UIScrollView tutorial, you will add a UIPageControl to your application.
 Fortunately, UIPageViewController has the ability to automatically provide a UIPageControl.
 To do so, your UIPageViewController must have a transition style of UIPageViewControllerTransitionStyleScroll, and you must provide implementations of two special methods on UIPageViewControllerDataSource. You previously set the Transition Style- great job!- so all you need to do is add these two methods inside the UIPageViewControllerDataSource extension on ManagePageViewController:
 */


import UIKit

final class PhotosBrowserViewController: UIPageViewController {

    var photos: [String] = []
    
    /// present时的index (即显示第几张图)
    var presentIndex: Int = 0
    
    var transitioning = PhotosBrowserTransition()

    /// 从上一页面的view弹出的views数组，分别与其photoIndex对应
    var fromViewArray: [UIView]?
    
    /// 用于状态栏显示/隐藏 避免底层的viewController present时状态栏突变
    var isViewDidAppear: Bool = false

    
    /// - Paramaters:
    ///     - photos: Array of photo urls.
    ///     - presentIndex: The index of present, default value is 0.
    ///     - fromViewArray: The array contains view from which PhotosBrowserViewController presented transition.
    init(photos: [String], presentIndex: Int = 0, fromViewArray: [UIView]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 8.0])

        self.photos = photos
        self.presentIndex = presentIndex
        self.fromViewArray = fromViewArray
        
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true
        self.transitioningDelegate = transitioning
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        dataSource = self
        
        let viewController = zoomedPhotoController(index: presentIndex)
        let viewControllers = [viewController]
        setViewControllers(viewControllers,
                           direction: .forward,
                           animated: false,
                           completion: nil)
        
        
        // Customize the colors of the UIPageControl.
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isViewDidAppear = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    deinit {
        print("\(self) deinit")
    }

    override var prefersStatusBarHidden: Bool {
        return isViewDidAppear ? true : false
    }
    
    private func zoomedPhotoController(index: Int) -> PhotoZoomedViewController {
        return PhotoZoomedViewController(photoIndex: index, photoName: photos[index], placeholderPhotoName: nil)
    }
}

extension PhotosBrowserViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PhotoZoomedViewController,
            let index = viewController.photoIndex, index > photos.startIndex
        {
            return zoomedPhotoController(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PhotoZoomedViewController,
            let index = viewController.photoIndex, index < photos.endIndex - 1
        {
            return zoomedPhotoController(index: index + 1)
        }
        return nil
    }
    
    // MARK: - UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return photos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return presentIndex
    }
}

// MARK: - 用于present/dismiss时图片的过渡效果
extension PhotosBrowserViewController {
    
    /// 当前index
    /// (本以为没法实现currentIndex，经测试 还是能给它加上，因为初始状态或每次切换后 self.viewControllers.count都为1，毕竟若不能实现currentIndex，即无法实现图片的转换过渡，在本需求中就得放弃使用UIPageController做了，有点叼)
    var currentIndex: Int {
        if let zoomedPhotoVC = viewControllers?.first as? PhotoZoomedViewController,
            let index = photos.index(of: zoomedPhotoVC.photoName) {
            return index
        }
        return 0
    }
    
    /// present开始时，tempImageView的frame
    var imageStartFrameOfPresent: CGRect? {
        guard let fromViewArray = fromViewArray, currentIndex >= 0, currentIndex < fromViewArray.endIndex else { return nil }
        let v = fromViewArray[currentIndex]
        let rect = v.convert(v.bounds, to: nil)
        return rect
    }
    
    /// dismiss完成时，tempImageView的frame
    var imageEndFrameOfDismiss: CGRect? {
        guard let fromViewArray = fromViewArray, currentIndex >= 0, currentIndex < fromViewArray.endIndex else { return nil }
        let v = fromViewArray[currentIndex]
        let rect = v.convert(v.bounds, to: nil)
        return rect
    }
    
    /// present完成时，imageView的frame
    var imageEndFrameOfPresent: CGRect? {
        if let zoomedPhotoVC = viewControllers?.first as? PhotoZoomedViewController
        {
            return zoomedPhotoVC.imageEndFrameOfPresent
        }
        return nil
    }
    
    /// dismiss开始时，imageView的frame
    var imageStartFrameOfDismiss: CGRect? {
        if let zoomedPhotoVC = viewControllers?.first as? PhotoZoomedViewController
        {
            return zoomedPhotoVC.imageStartFrameOfDismiss
        }
        return nil
    }
    
    /// present时的image
    var imageOfPresent: UIImage? {
        if let zoomedPhotoVC = viewControllers?.first as? PhotoZoomedViewController
        {
            return zoomedPhotoVC.initializedPhoto
        }
        return nil
    }
    
    /// present时的imageView
    var currentImageView: UIImageView? {
        if let zoomedPhotoVC = viewControllers?.first as? PhotoZoomedViewController
        {
            return zoomedPhotoVC.imageView
        }
        return nil
    }
}
