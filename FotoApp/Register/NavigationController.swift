//
//  NavigationController.swift
//  FotoApp
//
//  Created by Valerio Ly on 11/12/18.
//

import UIKit

class NavigationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     self.performSegue(withIdentifier: "segueNavigation", sender: nil)
    }
    

  

}
