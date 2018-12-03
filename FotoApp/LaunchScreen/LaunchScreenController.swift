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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // checked if user is logged
        checkedLoggedUser { (success) in
            if success {
                self.performSegue(withIdentifier: "", sender: self)
            }
            else {
                self.performSegue(withIdentifier: R.segue.launchScreenController.segueToAuth.identifier, sender: self)
            }
        }
    }
    
    func checkedLoggedUser(completion : @escaping (Bool) -> ()) {
        if Auth.auth().currentUser != nil {
            completion(true)
        }
        else {
            completion(false)
        }
    }
}
