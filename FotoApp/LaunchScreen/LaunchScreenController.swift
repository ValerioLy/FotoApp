//
//  LaunchScreenController.swift
//  FotoApp
//
//  Created by Nicola on 03/12/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // large titles
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // checked if user is logged
        NetworkManager.checkedLoggedUser { (success) in
            if success {
                self.performSegue(withIdentifier: "segueToHome", sender: self)
            }
            else {
                self.performSegue(withIdentifier: R.segue.launchScreenController.segueToAuth.identifier, sender: self)
            }
        }
    }
}
