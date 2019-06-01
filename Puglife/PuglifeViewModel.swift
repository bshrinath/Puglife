//
//  PuglifeViewModel.swift
//  Puglife
//
//  Created by Shrinath Badrinarayanan on 5/23/19.
//  Copyright © 2019 Halcyon. All rights reserved.
//

import Foundation
import UIKit

struct PuglifeViewModel {
    
    var imageURL: String?
    var likes: Int
    var isLiked: Bool
    
    init(imageURL: String) {
        self.imageURL = imageURL
        self.likes = Int.random(in: 1...1000)
        self.isLiked = false
    }
    
}
