//
//  CreditsViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 03/12/2018.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = """
        Made with 🖤 by:
        Francesco Baldan
        Nicola Pagiaro
        Marco Cozza
        Valerio Li
        Alessio Lasta
        Gianluca Canova
        """
    }
    

}
