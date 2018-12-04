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
    static func image(from url : String, completion: @escaping (Data?, Bool) -> ()) {
        getData(from: URL(string: url)!) { (imageData, urlResponse, err) in
            if imageData != nil {
                completion(imageData, true)
                return
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
