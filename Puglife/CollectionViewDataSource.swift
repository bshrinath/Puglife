//
//  CollectionViewDataSource.swift
//  Puglife
//
//  Created by Shrinath Badrinarayanan on 5/23/19.
//  Copyright © 2019 Halcyon. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var pugCollection = [PuglifeViewModel]()
    weak var cellDelegate: CollectionCellDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pugCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        cell.delegate = cellDelegate
        cell.configure(with: pugCollection[indexPath.row])
        return cell
    }
}
