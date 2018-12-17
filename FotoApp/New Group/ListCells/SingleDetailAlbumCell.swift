//
//  SingleDetailAlbumCell.swift
//  FotoApp
//
//  Created by Nicola on 11/12/18.
//

import UIKit

class SingleDetailAlbumCell: UITableViewCell {
    static let kIdentifier = "singleDetailAlbumCell"

    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var otherInfoLabel: UILabel!
    @IBOutlet weak var pendingDeletion: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(album : Album)  {
        descrLabel.text = album.descr
        let date = album.dateAdd.date?.stringFormatted ?? ""
        otherInfoLabel.text = "Creato da " + album.createdByName + " il " + date
        pendingDeletion.isOn = album.isPendingForDeletion ?? false
    }
}
