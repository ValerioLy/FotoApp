//
//  ViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 03/12/2018.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase

class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        NetworkManager.logout { (success) in
            if success {
                GeneralUtils.share.reloadGenericViewController(storyboardName: "AuthScreen", controllerIdentifier: "AuthScreen")
                self.performSegue(withIdentifier: "authSegue", sender: nil)
            }
        }
    }
    
    @IBAction func creditsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreditSegue", sender: nil)
    }
    @IBAction func infoAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toInfoSegue", sender: nil)

    }


}
