//
//  SingleLineAction.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit

class SingleLineActionController: UICollectionViewCell {
    static let kIdentifier = "singleLineActionController"
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    
    func setup(actionNameStr : String) {
        textLabel.text = actionNameStr
    }
}
