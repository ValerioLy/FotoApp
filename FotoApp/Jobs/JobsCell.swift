//
//  JobsCell.swift
//  FotoApp
//
//  Created by Marco Cozza on 04/12/2018.
//

import UIKit

class JobsCell: UITableViewCell {

    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var missionDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func downloadImage(id : String?, url: URL) {
        
        NetworkImageManager.image(with: id, from: url.absoluteString) { (imageData, success) in
            DispatchQueue.main.async {
                if success {
                    self.imageOutlet.roundedCorners()
                    self.imageOutlet.image = UIImage(data: imageData!)
                }
            }
            
        }
    }

}
