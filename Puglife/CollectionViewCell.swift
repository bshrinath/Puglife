//
//  CollectionViewCell.swift
//  Puglife
//
//  Created by Shrinath Badrinarayanan on 5/23/19.
//  Copyright © 2019 Halcyon. All rights reserved.
//

import UIKit

protocol CollectionCellDelegate: class {
    func didLikeImageAt(cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    weak var delegate: CollectionCellDelegate?
    
    var imageURL: String? {
        didSet {
            ImageRequestHandler.fetchImage(for: imageURL!) { image, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    self.set(image: image)
                }
            }
        }
    }

    func set(image: UIImage?) {
        imageView.image = image
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        likeButton.isSelected = !likeButton.isSelected
        delegate?.didLikeImageAt(cell: self)
    }
    
    func configure(with model: PuglifeViewModel) {
        imageURL = model.imageURL
        likeButton.isSelected = model.isLiked
        updateLikesLabel(likes: model.likes)
    }
    
    func updateLikesLabel(likes: Int) {
        let likesText = likes > 1 ? "likes" : "like"
        likesLabel.text = "\(likes) \(likesText)"
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        likesLabel.text = nil
    }
}
