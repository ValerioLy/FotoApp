//
//  TopicAlbumsTableViewCell.swift
//  FotoApp
//
//  Created by Alessio Lasta on 12/12/2018.
//

import UIKit

class TopicAlbumsTableViewCell: UITableViewCell {
    
    
    static let kIdentifier = "TopicAlbumsTableViewCell"
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var photos: UILabel!
    @IBOutlet weak var toDeleteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
