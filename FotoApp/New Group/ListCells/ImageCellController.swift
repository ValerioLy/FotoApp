//
//  ImageCellController.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit
import SkeletonView

class ImageCellController: UICollectionViewCell {
    static let kIdentifier = "imageCell"
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setup(with image : Photo) {
        // skeleton cool effect
        imageView.isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        imageView.roundedCorners()
        
        // load the image
        NetworkImageManager.image(with: image.id, from: image.link) { (imageData, success) in
            DispatchQueue.main.async {
                if success {
                    self.imageView.hideSkeleton()
                    self.imageView.image = UIImage(data: imageData!)
                    self.imageView.roundedCorners()
                }
            }
        }
    }
}
