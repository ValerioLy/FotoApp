//
//  Extensions.swift
//  FotoApp
//
//  Created by Valerio Ly on 28/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//
import UIKit
import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
}
}
/*extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 80.0)
    }
    
}
*/
