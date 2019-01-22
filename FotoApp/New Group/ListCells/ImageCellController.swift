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
    @IBOutlet weak var imageNumber: UILabel!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setup(with image : Photo, number : Int) {
        // set the index of the image
        imageNumber.text = "\(number)"
        
        // skeleton cool effect
        imageView.isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        imageView.roundedCorners()
        
        imageNumber.clipsToBounds = true
        imageNumber.layer.cornerRadius = imageNumber.frame.width/2
        imageNumber.layer.borderColor = UIColor.white.cgColor
        imageNumber.layer.borderWidth = CGFloat(8)

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
