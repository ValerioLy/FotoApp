//
//  Extension.swift
//  FotoApp
//
//  Created by Nicola on 03/12/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func roundedCorners() {
        self.layer.cornerRadius = CGFloat(8)
        self.clipsToBounds = true
    }
}
