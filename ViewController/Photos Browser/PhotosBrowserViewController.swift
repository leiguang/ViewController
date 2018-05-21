//
//  PhotosBrowserViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/21.
//  Copyright © 2018年 leiguang. All rights reserved.
//

// [UIScrollView Tutorial](https://www.raywenderlich.com/159481/uiscrollview-tutorial-getting-started)

import UIKit

class PhotosBrowserViewController: UIPageViewController {

    var photos: [String] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .red
        
        
        dataSource = self
        
        let viewController = viewPhotoController(index: currentIndex)
        let viewControllers = [viewController]
        setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
    }

    private func viewPhotoController(index: Int) -> ZoomedPhotoViewController {
        let page = ZoomedPhotoViewController()
//        let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomedPhotoViewController") as! ZoomedPhotoViewController
        page.photoName = photos[index]
        page.photoIndex = index
        return page
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension PhotosBrowserViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ZoomedPhotoViewController,
            let index = viewController.photoIndex, index > photos.startIndex
        {
            return viewPhotoController(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ZoomedPhotoViewController,
            let index = viewController.photoIndex, index < photos.endIndex - 1
        {
            return viewPhotoController(index: index + 1)
        }
        return nil
    }
    
    // MARK: - UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return photos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}
