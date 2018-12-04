//
//  ViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 03/12/2018.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        /*
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            completion(true)
        }   catch let error as NSError {
            print("Error signing out : %ç@", error)
            
            UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: "Error", message: error.localizedDescription, closeAction: {
                completion(false)
            }), animated: true, completion: nil)
        }
    }
    */
        
        
    }
    @IBAction func creditsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreditSegue", sender: nil)
    }
    @IBAction func infoAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toInfoSegue", sender: nil)

    }
}
