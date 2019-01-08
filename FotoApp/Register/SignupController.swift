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
    var hasInsertedData : Bool = false
    var hasAcceptedContract : Bool = false
    
    @IBOutlet weak var lblTxt: UILabel!{
        didSet {
            lblTxt.text = R.string.localizable.kSignuplbl()
        }
    }
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var signupOutlet: UIButton! {
        didSet {
            signupOutlet.roundedCorners()
            signupOutlet.setTitle(R.string.localizable.kSignupButton(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // green color to back button
        self.navigationController?.navigationBar.tintColor = UIColor.primaryColor
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
            self.present(UIApplication.alertError(title: R.string.localizable.kAlertLoginFailedEmptyLabelsTitle(), message: R.string.localizable.kAlertLoginFailedEmptyLabelsMessage().localized, closeAction:{}), animated: true, completion: nil)
            return
        }
        
        guard password == repassword else {
            self.present(UIApplication.alertError(title: R.string.localizable.kAlertLoginFailedDifferentPasswordsTitle(), message: R.string.localizable.kAlertLoginFailedDifferentPasswordsMessage(), closeAction:{}), animated: true, completion: nil)
            return
        }
        
        guard password.count > 5 else {
            self.present(UIApplication.alertError(title: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle(), message: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle(), closeAction:{}), animated: true, completion: nil)
            return
        }
        
        let loadingAlert = UIApplication.loadingAlert(title: "Registration")
        self.present(loadingAlert, animated: true, completion: {})
        
        NetworkManager.register(email: email, password: password) { (success, err) in
            loadingAlert.dismiss(animated: true, completion: {
                if success {
                    
                    NetworkManager.pushUserData(email: email, hasInsertedData: self.hasInsertedData, hasAcceptedContract : self.hasAcceptedContract, completion: { (success, err) in
                        if success {
                            self.performSegue(withIdentifier:"segueToUserInfo", sender: self)
                            
                        }
                        else {
                            let alert = UIApplication.alertError(title: "Opss", message: err, closeAction: {})
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
                else {
                    let alert = UIApplication.alertError(title: "Opss", message: err, closeAction: {})
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
}
