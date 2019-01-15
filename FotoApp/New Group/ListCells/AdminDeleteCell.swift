//
//  AdminDeleteCell.swift
//  FotoApp
//
//  Created by Nicola on 14/01/19.
//

import UIKit

class AdminDeleteCell: UITableViewCell {
    static let kIdentifier = "adminDeleteCell"
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.roundedCorners()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
