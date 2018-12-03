//
//  GeneralUtils.swift
//  FotoApp
//
//  Created by Valerio Ly on 30/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//


import UIKit

class GeneralUtils: NSObject {
    
    static let share = GeneralUtils()
    
    func alertError(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        return alert
}


}
