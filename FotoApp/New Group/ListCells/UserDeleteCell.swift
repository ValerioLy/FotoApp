//
//  UserDeleteCell.swift
//  FotoApp
//
//  Created by Nicola on 14/01/19.
//

import UIKit

class UserDeleteCell: UITableViewCell {
    static let kIdentifier = "userDeleteCell"
    @IBOutlet weak var daEliminareSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(isPending : Bool) {
        daEliminareSwitch.isOn = isPending
    }

}
