//
//  SignupController.swift
//  FotoApp
//
//  Created by Valerio Ly on 28/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController {

    enum TagFields : Int {
        case email = 0
        case password
        case repeatpassword
    }
    
    @IBOutlet weak var lblTxt: UILabel!{
        didSet {
            lblTxt.text = R.string.localizable.kSignuplbl()
        }
    }
    
    
   
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var signupOutlet: UIButton! {
        didSet {
            signupOutlet.layer.cornerRadius = 5
            signupOutlet.setTitle(R.string.localizable.kSignupButton(), for: .normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
   
    @IBAction func signupAction(_ sender: Any) {
        var email : String = ""
        var password : String = ""
        var repassword : String = ""
        
        for textField in textFields {
            switch textField.tag {
            case TagFields.email.rawValue:
                email = textField.text ?? ""
            case TagFields.password.rawValue:
                password = textField.text ?? ""
            case TagFields.repeatpassword.rawValue:
                repassword = textField.text ?? ""
            default:
                break
            }
        }
        
        
        guard !email.isEmpty && !password.isEmpty && !repassword.isEmpty else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedEmptyLabelsTitle(), message: R.string.localizable.kAlertLoginFailedEmptyLabelsMessage().localized), animated: true, completion: nil)
            return
        }
        
        guard email.isValidEmail() else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedEmptyLabelsTitle(), message: R.string.localizable.kAlertLoginFailedInvalidEmailMessage()), animated: true, completion: nil)
            return
        }
        
        guard password == repassword else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedDifferentPasswordsTitle(), message: R.string.localizable.kAlertLoginFailedDifferentPasswordsMessage()), animated: true, completion: nil)
            return
        }
        
        guard password.count > 5 else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle(), message: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle()), animated: true, completion: nil)
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("registrazione effettuata")
                  self.performSegue(withIdentifier: "segueUserInfo", sender: nil)
            } else {
                let alert = UIAlertController(title: "OPS", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
           
            }
        }
    }
    
}
