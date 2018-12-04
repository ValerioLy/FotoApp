//
//  ImageCellController.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit

class ImageCellController: UICollectionViewCell {
    static let kIdentifier = "imageCell"
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setup(with image : Photo) {
        imageView.roundedCorners()
        
        // load the image
        NetworkImageManager.image(from: image.link) { (imageData, success) in
            DispatchQueue.main.async {
                if success {
                    self.imageView.image = UIImage(data: imageData!)
                }
            }
        }
    }
}
