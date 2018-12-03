//
//  LoginViewController.swift
//  FotoApp
//
//  Created by Jason Bourne on 28/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CodableFirebase

class LoginViewController: UIViewController {
    enum TextType : Int {
        case email = 0
        case password
    }
    @IBOutlet var textfields: [UITextField]!
    
    @IBOutlet weak var register: UIBarButtonItem!{
        didSet{
            register.title = "Register"
        }
    }
    
    @IBOutlet weak var forgot: UIButton!{
        didSet{
            forgot.setTitle("Forgot password", for: .normal)
        }
    }
    
    @IBOutlet weak var login: UIButton!{
        didSet{
            login.setTitle("Login", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        var email : String = ""
        var password : String = ""
        
        for textField in textfields {
            switch textField.tag {
            case TextType.email.rawValue:
                email = textField.text ?? ""
            case TextType.password.rawValue:
                password = textField.text ?? ""
            default:
                break
            }
        }
        
        guard !email.isEmpty && !password.isEmpty  else {
            self.present(UIApplication.alertError(title: "Failed Empty Labels Title", message: "Login Failed Empty Labels", closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard password.count > 5 else {
            self.present(UIApplication.alertError(title: "Login Failed Invalid Password", message: "Login Failed Invalid Password".localized, closeAction: {}),  animated: true, completion: nil)
            return
        }
        
        NetworkManager.login(email: email, password: password) { (success) in
            if success {
                self.present(UIApplication.alertError(title: "Login Success", message: "Login success".localized, closeAction: {}),  animated: true, completion: nil)
                /*self.performSegue(withIdentifier: R.segue.loginController.segueToMain, sender: self)*/
            }
        }
    }
}
