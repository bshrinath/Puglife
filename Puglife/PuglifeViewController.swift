//
//  PuglifeViewController.swift
//  Puglife
//
//  Created by Shrinath Badrinarayanan on 5/23/19.
//  Copyright © 2019 Halcyon. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PuglifeViewController: UICollectionViewController, NVActivityIndicatorViewable {
    
    var dataSource = CollectionViewDataSource()
    var shouldLoadMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: 471)
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        dataSource.cellDelegate = self
        fetchImageUrls()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if yOffset > contentHeight - scrollView.frame.size.height,
            contentHeight > 0.0,
            shouldLoadMore {
            fetchImageUrls()
            shouldLoadMore = false
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        shouldLoadMore = true
    }
    
    func fetchImageUrls() {
        startAnimating(CGSize(width: 40, height: 40), message: "Loading images", messageFont: .systemFont(ofSize: 20), type: .circleStrokeSpin, color: .white, padding: 40, minimumDisplayTime: 1000, textColor: .white)
        
        ImageRequestHandler.fetchImageUrls { imageUrls, error  in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let imageUrls = imageUrls else {
                return
            }
            
            for url in imageUrls {
                guard let _ = URL(string: url) else {
                    print("Not a valid image url: \(url)")
                    continue
                }
                let viewModel = PuglifeViewModel(imageURL: url)
                self.dataSource.pugCollection.append(viewModel)
            }
        
            DispatchQueue.main.async {
                self.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
}

extension PuglifeViewController: CollectionCellDelegate {
    func didLikeImageAt(cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let index = indexPath.row
        dataSource.pugCollection[index].isLiked = cell.likeButton.isSelected
        if cell.likeButton.isSelected {
            dataSource.pugCollection[index].likes += 1
        } else {
            dataSource.pugCollection[index].likes -= 1
        }
        cell.updateLikesLabel(likes: dataSource.pugCollection[index].likes)
    }
}
