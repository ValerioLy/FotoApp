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
            register.tintColor = UIColor(red: CGFloat(29)/CGFloat(255),
                                         green: CGFloat(146)/CGFloat(255),
                                         blue: CGFloat(98)/CGFloat(255),
                                         alpha: 1)
            
        }
    }
    
    @IBOutlet weak var forgot: UIButton!{
        didSet{
            forgot.setTitle("Forgot password", for: .normal)
            forgot.setTitleColor(UIColor(red: CGFloat(29)/CGFloat(255),
                                         green: CGFloat(146)/CGFloat(255),
                                         blue: CGFloat(98)/CGFloat(255),
                                         alpha: 1), for: .normal)
        }
    }
    
    @IBOutlet weak var login: UIButton!{
        didSet{
            login.setTitle("Sign in", for: .normal)
            
            let start : CGPoint = CGPoint(x: 1.0, y: 1.0)
            let end : CGPoint = CGPoint(x: 1.0, y: 0.0)
            let gradient: CAGradientLayer = CAGradientLayer(layer: login)
            gradient.colors = [(UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 1.00).cgColor), (UIColor(red: 29.0/255.0, green: 146.0/255.0, blue: 98.0/255.0, alpha: 1.00).cgColor)]
            gradient.locations = [0.0 , 1.0]
            
            gradient.startPoint = start
            gradient.endPoint = end
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: login.frame.size.width, height: login.frame.size.height)
            
            
            login.layer.insertSublayer(gradient, at: 0)
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
        
        NetworkManager.login(email: email, password: password) { (success, err) in
            if success {
                self.present(UIApplication.alertError(title: "Login Success", message: "Login success".localized, closeAction: {}),  animated: true, completion: nil)
                /*self.performSegue(withIdentifier: R.segue.loginController.segueToMain, sender: self)*/
            }
        }
    }
    
    @IBAction func forgotAction(_ sender: UIButton) {
        /*self.performSegue(withIdentifier: R.segue.loginController.segueToMain, sender: self)*/
    }
    
    
    @IBAction func registerAction(_ sender: UIBarButtonItem) {
        /*self.performSegue(withIdentifier: R.segue.loginController.segueToMain, sender: self)*/
    }
}
