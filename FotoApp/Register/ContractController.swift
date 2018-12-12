//
//  ContractController.swift
//  FotoApp
//
//  Created by Valerio Ly on 01/12/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit

class ContractController: UIViewController {

    var hasAcceptedContract : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide back button
         self.navigationItem.setHidesBackButton(true, animated:true)
    }

    @IBAction func AcceptAction(_ sender: UIBarButtonItem) {
        NetworkManager.updateTerms(hasAcceptedContract: true) { (success) in
            if success {
                self.performSegue(withIdentifier: "segueJobs", sender: self)
            }
            else {
                // error handling
            }
        }
        
        
    }
}
