//
//  PhotoZoomedViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/21.
//  Copyright © 2018年 leiguang. All rights reserved.
//

/**
 Notes:
 You can initialize the imageView using a placeholder image, and then reset "imageView.image = .." until the HD image loaded successfully.
 But be carefully, if you set the image after imageView initialization, you must explict call the "imageView.sizeToFit()" method to resize imageView's size. (Note: In this case, also remeber to call "updateMinZoomScale(forSize: )" method)

    eg: self.imageView.image = UIImage(named: "leiguang")
        self.imageView.sizeToFit()
        self.updateMinZoomScale(forSize: self.view.bounds.size)
 */

import UIKit

final class PhotoZoomedViewController: UIViewController {
    
    var photoIndex: Int!
    var photoName: String!
    var placeholderPhotoName: String?
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    
    
    lazy var imageView: UIImageView = {
        /// 若加载网络图片，在创建图片时，如果本地有缓存，则从本地取，本地没有，则使用默认图替代，待大图下载完成再重新赋值。 See Notes 👆
        let image = UIImage(named: photoName)!
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    

    private var imageViewTopConstraint: NSLayoutConstraint!
    private var imageViewBottomConstraint: NSLayoutConstraint!
    private var imageViewLeadingConstraint: NSLayoutConstraint!
    private var imageViewTrailingConstraint: NSLayoutConstraint!
    
    /// 占位图（或小图），可用来模拟加载网络图片。
    init(photoIndex: Int, photoName: String, placeholderPhotoName: String?) {
        self.photoIndex = photoIndex
        self.photoName = photoName
        self.placeholderPhotoName = placeholderPhotoName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        setConstraints()
        addGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Using for debug
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            print("scrollView: \(self.scrollView.hasAmbiguousLayout), \(self.scrollView.frame)")
//            print("imageView: \(self.imageView.hasAmbiguousLayout), \(self.imageView.frame)")
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.imageView.image = UIImage(named: "temp")
//            self.imageView.sizeToFit()
//            self.updateMinZoomScale(forSize: self.view.bounds.size)
////            self.updateConstraints(forSize: self.view.bounds.size)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: view.bounds.size)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    private func setConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        NSLayoutConstraint.activate([
            imageViewTopConstraint,
            imageViewBottomConstraint,
            imageViewLeadingConstraint,
            imageViewTrailingConstraint,
            ])
    }
    
    private func updateConstraints(forSize size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    private func updateMinZoomScale(forSize size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        /// set up the init zoom scale
        scrollView.zoomScale = minScale
    }
    
    // MARK: - Gestures
    private func addGestures() {
        // single tap to dismiss
        let generalTapGesture = UITapGestureRecognizer(target: self, action: Selector.generalTap)
        view.addGestureRecognizer(generalTapGesture)
        
        // for zoom
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector.doubleTap)
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        
        // Creates a dependency relationship between generalTapGesture and doubleTapGesture.
        generalTapGesture.require(toFail: doubleTapGesture)

        
        // Find and hook the scrollView's pan gesture, add a swipe down operation to it.
        // (I have tried to add a UISwipeGesture to scrollView, but swipeGesture will be blocked)
        if let gestures = scrollView.gestureRecognizers {
            for gesture in gestures {
                if gesture is UIPanGestureRecognizer {
                    gesture.addTarget(self, action: Selector.swipeDown)
                }
            }
        }
    }
    
    @objc func generalTap(gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.maximumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let location = gesture.location(in: imageView)
            let zoomRect = zoomRectForScrollView(scrollView, scale: scrollView.maximumZoomScale, center: location)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    @objc func swipeDown(gesture: UIPanGestureRecognizer) {
//        print(gesture.translation(in: scrollView).y)
//        print(gesture.velocity(in: scrollView).y)
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: scrollView)
        case .ended:
            let offsetY = gesture.translation(in: scrollView).y
            let velocityY = gesture.velocity(in: scrollView).y
            if offsetY > 100 && velocityY > 1000 {   // 偏移量达到100pt，且速度达到800pt/s，则dismiss
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    /// A utility method that converts a specified scale and center point to a rectangle for zooming
    private func zoomRectForScrollView(_ scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect: CGRect = .zero

        // The zoom rect is the content view's coordinates.
        // At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
        // As the zoom scale decreases, so more content is visible, the size of the rect grows.
        zoomRect.size.width = scrollView.bounds.width / scale
        zoomRect.size.height = scrollView.bounds.height / scale

        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.height / 2.0)
        
        return zoomRect
    }
}

// MAKR: - UIScrollViewDelegate
extension PhotoZoomedViewController: UIScrollViewDelegate {
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// Called every time zoom in or out the scroll View, use this method to center the image, otherwise it will be pinned to the top of the scroll view.
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(forSize: view.bounds.size)
    }
}

// MARK: - 用于present/dismiss时图片的过渡效果
extension PhotoZoomedViewController {
    
    /// present完成时imageView的frame
    var imageEndFrameOfPresent: CGRect? {
        guard let image = UIImage(named: photoName) else { return nil }
        
        // 由于使用AutoLayout做的，所以如果要添加点击present的图片过渡效果，得手动再算一遍图片的终点位置。
        
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height - kSafeAreaBottom - 37.0  // UIPageControl 高37.0
        
        let centerX = viewWidth / 2
        let centerY = viewHeight / 2
        
        let widthScale = viewWidth / image.size.width
        let heightScale = viewHeight / image.size.height
        let minScale = min(widthScale, heightScale)
        
        let width = image.size.width * minScale
        let height = image.size.height * minScale
        
        return CGRect(x: centerX - width / 2,
                      y: centerY - height / 2,
                      width: width,
                      height: height)
    }
    
    /// dismiss开始时imageView的frame
    var imageStartFrameOfDismiss: CGRect {
        return imageView.frame
    }
}

fileprivate extension Selector {
    static let generalTap = #selector(PhotoZoomedViewController.generalTap(gesture:))
    static let doubleTap = #selector(PhotoZoomedViewController.doubleTap(gesture:))
    static let swipeDown = #selector(PhotoZoomedViewController.swipeDown(gesture:))
}
