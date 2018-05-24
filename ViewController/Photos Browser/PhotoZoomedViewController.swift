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
        self.updateMinZoomScale(forSize: scrollView.bounds.size)
 */

/**
 测试发现:
    当缩放时，改变的是imageView的frame；
    当拖动产生bounces效果时，改变的是imageView的transform，而frame是固定不变的 (因此在图片处于原位时可以加此判断)。
 
 由于下拉dismiss时，图片会从未缩放的起始位置开始执行动画，会导致dismiss动画的显示有闪变。
 可优化处：执行dismiss时，可以将当前transform的变化量加上图片transform前的位置 计算出的位置， 用于dismiss的tempImageView的起始位置
 
 在pan dismiss手势中，如果图片处于起始位置，且拖拽结束时手势的偏移量 比图片未缩放时的起始位置大100，则dismiss
 */

import UIKit

final class PhotoZoomedViewController: UIViewController {
    
    var photoIndex: Int!
    var photoName: String!
    var placeholderPhotoName: String?
    
    
    lazy var scrollView: UIScrollView = { [weak self] in
        let scrollView = UIScrollView()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false 
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: initializedPhoto)
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// 显示时初始化时的photo
    lazy var initializedPhoto: UIImage = {
        /// 若加载网络图片，在创建图片时，如果本地有缓存，则从本地取，本地没有，则使用默认图替代，待大图下载完成再重新赋值。 See Notes 👆
        
        return UIImage(named: photoName)!
    }()
    

    private var imageViewTopConstraint: NSLayoutConstraint!
    private var imageViewBottomConstraint: NSLayoutConstraint!
    private var imageViewLeadingConstraint: NSLayoutConstraint!
    private var imageViewTrailingConstraint: NSLayoutConstraint!
    
    /// 占位图（或小图），可用来模拟加载网络图片。
    init(photoIndex: Int, photoName: String, placeholderPhotoName: String? = nil) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: scrollView.bounds.size)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    /// 重新设置图片
    private func resetImage(_ image: UIImage) {
        /// 这里，由于直接对“imageView.sizeToFit()、updateMinZoomScale()”做UIView.animate()动画会出现看起来先放大再缩小的问题，造成不好的视觉效果，因此这里采取先保存动画前旧image前的frame，更新约束后再做动画。
        let beforeFrame = currentImageInitFrame!
        
        self.imageView.image = image
        self.imageView.sizeToFit()
        self.updateMinZoomScale(forSize: self.scrollView.bounds.size)
        
        let afterFrame = currentImageInitFrame!
        
        self.imageView.frame = beforeFrame
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imageView.frame = afterFrame
        }, completion: nil)
    }
    
    private func setConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: scrollViewTopMargin),
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
        
        updateConstraints(forSize: scrollView.bounds.size)
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

        
        // Hook the scrollView's pan gesture, add a swipe down operation to it.
        // (I have tried to add a UISwipeGesture to scrollView, but swipeGesture will be blocked)
        scrollView.panGestureRecognizer.addTarget(self, action: Selector.swipeDown)
    }
    
    @objc func generalTap(gesture: UITapGestureRecognizer) {
        originOfDismissStart = imageView.frame.origin
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

    /// 用于执行下滑手势dismiss时，存储下滑手势开始时的scrollView的内容偏移量（注意!：手势偏移量并不等于内容偏移量）
    var oldContentOffset: CGPoint = .zero
    
    /// 执行dismiss时，存储imageView在scrollView的上的坐标原点，用于dismiss过渡动画 计算tempImageView在view上的起始位置  (2种情形：下滑手势结束时、或单击手势开始时)
    var originOfDismissStart: CGPoint = .zero
    
    @objc func swipeDown(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: scrollView)
        
            oldContentOffset = scrollView.contentOffset
            
        case .ended:
            let offsetY = gesture.translation(in: scrollView).y
            let velocityY = gesture.velocity(in: scrollView).y

            // 1. 偏移量达到100pt，且速度达到800pt/s，则dismiss.
            // 2. 如果是从当前图片未被缩放/平移 的起始点，向下偏移了100，则dismiss. (由于AutoLayout和frame的不同计算会带有小数点，直接允许10pt的误差吧)
            if (offsetY > 100 && velocityY > 1000) ||
                (currentImageInitFrame != nil && fabs(imageView.frame.minY - currentImageInitFrame!.minY) < 10.0 && offsetY > 100)
                {
                    // 由于 此时pan手势前后 imageView的 frame、center、transform都未变化（但是打印发现bounds有变化），  可以直接使用它的frame作为 滑动手势执行前的frame
                    var x = imageView.frame.origin.x
                    var y = imageView.frame.origin.y
                    
                    // 计算scrollView的内容偏移量（注意!：手势偏移量并不等于内容偏移量）
                    x += -(scrollView.contentOffset.x - oldContentOffset.x)
                    y += -(scrollView.contentOffset.y - oldContentOffset.y)
                    
                    originOfDismissStart = CGPoint(x: x, y: y)
                
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
        updateConstraints(forSize: scrollView.bounds.size)
    }
}

// MARK: - 用于present/dismiss时图片的过渡效果
extension PhotoZoomedViewController {
    
    /// 当前image缩放前的起始frame (如果有大图，则是大图的起始frame，如果是小图，则是小图的起始frame)
    var currentImageInitFrame: CGRect? {
        guard let image = imageView.image else { return nil }
        return initFrameOfImage(image, isTransition: false)
    }
    
    /// present完成时imageView的frame
    var imageEndFrameOfPresent: CGRect {
        return initFrameOfImage(initializedPhoto, isTransition: true)
    }
    
    /// 计算image未被缩放时的起始frame
    /// 注意，有两种情形(两者的参考坐标系不同，scrollView在顶部安全区域内):
    /// 1. present/dismiss过渡时用于计算tempImageView在view上的frame；
    /// 2. 计算真实的imageView在scrollView上的初始frame
    func initFrameOfImage(_ image: UIImage, isTransition: Bool) -> CGRect {

        // 由于要添加点击present的图片过渡效果，得手动再算一遍图片的终点位置。
        // 如果 直接使用 view.bounds.widh/height，则在present前得出的宽高为屏幕宽高，在present完成后 又变成了去除安全边距、UIPageControl的宽高，会导致前后计算不一致，因此这里统一采用屏幕宽高来算
        
        let viewWidth = kScreenWidth
        let viewHeight = kScreenHeight - scrollViewTopMargin - kSafeAreaBottom - 37.0  // UIPageControl 高37.0
        
        let centerX = viewWidth / 2
        let centerY = viewHeight / 2 + (isTransition ? scrollViewTopMargin : 0) // 为了避免iPhone X上两只耳朵旁显示，scrollView在顶部的安全距离之下。因此这里计算完之后，要再加上kSafeAreaTop
        
        let widthScale = viewWidth / image.size.width
        let heightScale = viewHeight / image.size.height
        let minScale = min(widthScale, heightScale)
        
        let width = min(image.size.width * minScale, image.size.width)      // 如果图片宽度比屏幕宽度 小，则选择屏幕宽度
        let height = min(image.size.height * minScale, image.size.height)
        
        return CGRect(x: centerX - width / 2,
                      y: centerY - height / 2,
                      width: width,
                      height: height)
    }
    
    /// dismiss开始时imageView的frame
    var imageStartFrameOfDismiss: CGRect {

        let width = imageView.frame.width
        let height = imageView.frame.height

        let x = originOfDismissStart.x
        var y = originOfDismissStart.y

        y += scrollViewTopMargin      // 由于过渡时tempImageView是添加在view上的，坐标轴不同（真实的imageView对应scrollView，而tempImageView对应view），所以，要加上kSafeAreaTop

        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    /// scrollView距离顶部的距离， iPhone X 耳朵两边不显示(即状态栏不显示)，其它情况下 scrollView延伸到状态栏区域
    var scrollViewTopMargin: CGFloat {
        return kDevice_isIphoneX ? kSafeAreaTop : 0
    }
}

fileprivate extension Selector {
    static let generalTap = #selector(PhotoZoomedViewController.generalTap(gesture:))
    static let doubleTap = #selector(PhotoZoomedViewController.doubleTap(gesture:))
    static let swipeDown = #selector(PhotoZoomedViewController.swipeDown(gesture:))
}
