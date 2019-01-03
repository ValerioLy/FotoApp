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
    static func image(with id : String, from url : String, completion: @escaping (Data?, Bool) -> ()) {
        if let imageFound = DownloadedImage.getObject(withId: id) {
            completion(imageFound.data, true)
        }
        else {
            getData(from: URL(string: url)!) { (imageData, urlResponse, err) in
                if imageData != nil {
                    // save the image
                    DownloadedImage(id : id, data: imageData!).save()
                    
                    completion(imageData, true)
                    return
                }
                else {
                    completion(nil, false)
                    return
                }
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
