//
//  ZoomedPhotoViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/21.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController {

    var photoName: String!
    var photoIndex: Int!
   
    private var scrollView: UIScrollView!
    private var imageView: UIImageView!

    private var imageViewTopConstraint: NSLayoutConstraint!
    private var imageViewBottomConstraint: NSLayoutConstraint!
    private var imageViewLeadingConstraint: NSLayoutConstraint!
    private var imageViewTrailingConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var imageView: UIImageView!
//
//    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setConstraints()

        let generalTapGesture = UITapGestureRecognizer(target: self, action: Selector.generalTap)
        view.addGestureRecognizer(generalTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("scrollView: \(scrollView.hasAmbiguousLayout), \(scrollView.frame)")
        print("imageView: \(imageView.hasAmbiguousLayout), \(imageView.frame)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScale(forSize: view.bounds.size)
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
    
    private func setupUI() {
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        let image = UIImage(named: photoName)!
        imageView = UIImageView(image: image)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true 
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }

    private func setConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])

        
//        imageView.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
//        imageView.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        
        
//        let a = imageView.widthAnchor.constraint(equalToConstant: 100)
//        let b = imageView.heightAnchor.constraint(equalToConstant: 100)
//        a.priority = .defaultLow
//        b.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            imageViewTopConstraint,
            imageViewBottomConstraint,
            imageViewLeadingConstraint,
            imageViewTrailingConstraint,
            
//            a,
//            b,

//            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
//            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),
            ])
    }
    
    @objc func myDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ZoomedPhotoViewController: UIScrollViewDelegate {
    
    /// Tell the delegate that the imageView will be made smaller or bigger.
    ///
    /// - Parameter scrollView: scrollView delegate to current view controller
    /// - Returns: the view is zoomed in and out
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// Called every time zoom in or out the scroll View
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(forSize: view.bounds.size)
    }
}

fileprivate extension Selector {
    
    static let generalTap = #selector(ZoomedPhotoViewController.myDismiss)
    
}
