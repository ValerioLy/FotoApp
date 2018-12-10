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

        // Configure the view for the selected state
    }

}
