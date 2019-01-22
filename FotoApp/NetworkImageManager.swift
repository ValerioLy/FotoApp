//
//  NetworkImageManager.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import Foundation

class NetworkImageManager {
    
    //
    // TODO: descr
    //
    static func image(with id : String? = nil, from url : String, completion: @escaping (Data?, Bool) -> ()) {
        if let imageId = id, let imageFound = DownloadedImage.getObject(withId: imageId) {
            completion(imageFound.data, true)
        }
        else {
            if let url = URL(string: url) {
                getData(from: url) { (imageData, urlResponse, err) in
                    if imageData != nil {
                        // save the image
                        let imageId = (id != nil) ? id! : UUID().uuidString
                        DownloadedImage(id : imageId, data: imageData!).save()
                        
                        completion(imageData, true)
                        return
                    }
                    else {
                        completion(nil, false)
                        return
                    }
                }
            }
            else {
                completion(nil, false)
                return
            }
        }
    }
 
    
    //
    // Function that fetch data from internet
    //
    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
