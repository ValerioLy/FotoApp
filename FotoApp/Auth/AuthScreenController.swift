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
        
        // hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
