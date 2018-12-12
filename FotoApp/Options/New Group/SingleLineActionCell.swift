//
//  SingleLineActionCell.swift
//  FotoApp
//
//  Created by Nicola on 12/12/18.
//

import UIKit

class SingleLineActionCell: UITableViewCell {
    static let kIdentifier = "singleLineActionCell"

    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(actionName : String) {
        labelText.text = actionName
    }

}
