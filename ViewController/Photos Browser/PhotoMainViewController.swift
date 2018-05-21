//
//  PhotoMainViewController.swift
//  ViewController
//
//  Created by 雷广 on 2018/5/21.
//  Copyright © 2018年 leiguang. All rights reserved.
//

import UIKit

class PhotoMainViewController: UICollectionViewController {
    private let reuseIdentifier = "PhotoMainCell"
    private let thumbnailSize: CGFloat = 70.0
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
    private let photos = ["photo0", "photo1", "photo2", "photo3", "photo4"]
}

// MARK: - UICollectionViewDataSource
extension PhotoMainViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoMainCell
        let fullSizedImage = UIImage(named: photos[indexPath.row])
        cell.imageView.image = fullSizedImage?.thumbnailOfSize(thumbnailSize)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoMainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let pages = PhotosBrowserViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 8.0])
//        pages.photos = photos
//        pages.currentIndex = indexPath.row
//        present(pages, animated: true, completion: nil)
        
        let page = ZoomedPhotoViewController()
        page.photoName = photos[indexPath.row]
        page.photoIndex = indexPath.row
        present(page, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: thumbnailSize, height: thumbnailSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

fileprivate extension UIImage {
    
    func thumbnailOfSize(_ size: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return thumbnail
    }
}
