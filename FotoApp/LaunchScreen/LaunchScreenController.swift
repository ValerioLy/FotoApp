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
        
        // large title
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // checked if user is logged
        checkedLoggedUser { (success) in
            if success {
                print("loggato")
                NetworkManager.checkUserInfo(completion: { (success) in
                    if success {
                         print("ha inserito i dati")
                        
                        NetworkManager.checkTermsUser(completion: { (success) in
                            if success {
                                 self.performSegue(withIdentifier: "segueToHome", sender: self)
                            }
                            else {
                                                        let viewController : UIViewController = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "TermsController")
                                                        self.present(viewController, animated: true, completion: nil)
                            }
                        })

                      

                    }
                    else {
                         print("non ha inserito i dati")
                        let viewController : UIViewController = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "UserInfoController")
                        self.present(viewController, animated: true, completion: nil)
                    }
                   
                   
                })
                
            }
            else {
                print("non si è loggato")
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
