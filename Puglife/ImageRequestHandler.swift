//
//  ImageRequestHandler.swift
//  Puglife
//
//  Created by Shrinath Badrinarayanan on 5/23/19.
//  Copyright © 2019 Halcyon. All rights reserved.
//

import UIKit

public enum PLError: Error {
    case otherError(message: String)
}

extension PLError {
    public var localizedDescription: String {
        switch self {
        case .otherError(let message):
            return message
        }
    }
}

class ImageRequestHandler {
    
    static func fetchImageUrls(_ completion: @escaping([String]?, PLError?)->Void) {
        
        let url = "https://pugme.herokuapp.com/bomb?count=50"
        
        fetchData(from: url) { data, error in
            guard let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                let imageUrls = json["pugs"] as? [String] else {
                    
                    let error = PLError.otherError(message: "No data was returned from the server or the data failed to serialize")
                    completion(nil, error)
                    return
            }
            
            completion(imageUrls, error as? PLError)
        }
    }
    
    static func fetchImage(for url: String, _ completion: @escaping(UIImage?, PLError?) -> Void) {
        
        var image: UIImage?
        
        fetchData(from: url) { data, error in
            if let data = data {
                image = UIImage(data: data)
            }
            
            completion(image, error as? PLError)
        }
    }
    
    static func fetchData(from urlString: String, _ completion: @escaping(Data?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            let error = PLError.otherError(message: "Invalid URL: No data returned for URL: \(urlString)")
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            completion(data, error)
            
        }).resume()
    }
}
