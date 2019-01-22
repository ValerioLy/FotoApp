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
            deleteButton.layer.borderColor = UIColor.init(hexString: "#FF2600").cgColor
            deleteButton.layer.borderWidth = CGFloat(2)
            deleteButton.tintColor = UIColor.init(hexString: "#FF2600")
            deleteButton.layer.backgroundColor = UIColor.clear.cgColor
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
