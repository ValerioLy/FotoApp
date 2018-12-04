//
//  AuthScreenController.swift
//  FotoApp
//
//  Created by Nicola on 03/12/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//
import UIKit

class AuthScreenController: UIViewController {
    @IBOutlet weak var emailButton: UIButton! {
        didSet {
            emailButton.roundedCorners()
            emailButton.titleEdgeInsets.left = 24
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hides navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
