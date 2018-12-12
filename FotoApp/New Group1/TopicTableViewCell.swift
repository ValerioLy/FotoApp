//
//  TopicTableViewCell.swift
//  FotoApp
//
//  Created by Alessio Lasta on 12/12/2018.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    
    
    static let kIdentifier = "TopicTableViewCell"
    
    
    @IBOutlet weak var descTitle: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var albumsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
