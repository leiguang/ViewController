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
    private let photos = ["photo0", "photo1", "photo2", "photo3", "photo4", "photo5", "photo6", "photo7"]
    
    
    
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
        // 注意： 经测试发现 通过collectionView.visibleCells获取到的cell，不能保证顺序正确。
        let cells = (0..<photos.count).compactMap {
            collectionView.cellForItem(at: IndexPath(row: $0, section: 0))
        }
        
        let vc = PhotosBrowserViewController(photos: photos, presentIndex: indexPath.row, fromViewArray: cells)
        present(vc, animated: true, completion: nil)
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
