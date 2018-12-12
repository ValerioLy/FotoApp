//
//  ResetPasswordController.swift
//  FotoApp
//
//  Created by Valerio Ly on 12/12/18.
//

import UIKit
import  FirebaseStorage
import  Firebase

class ResetPasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBOutlet weak var cancelOutlet: UIButton! {
        didSet {
            cancelOutlet.roundedCorners()
        }
    }
    
    @IBOutlet weak var resetpasswordOutlet: UIButton!{
        didSet {
            resetpasswordOutlet.roundedCorners()
        }
    }
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBAction func resetPassword(_ sender: Any) {
        var email : String = ""
        email = emailField.text!
        
        guard !email.isEmpty  else {
            let alert = UIAlertController(title: "Email Vuota", message: "Non hai inserito l'email", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        ResetPassword(email: email) { (success) in
            if success {
                print("Email Inviata per il reset della password")
            }
        }
        
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func ResetPassword(email: String, completion: @escaping (Bool) -> ()) {
        
         Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let err = error{
                
                let alert = UIAlertController(title: "Email", message: "L'email \(email) non è presente nel Database", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Inserisci Email", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
                    
                completion(false)
            }
            else {
                let alert = UIAlertController(title: "Email", message: "L'email con il reset della password è stata inviata a \(email)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Inserisci Email", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
                completion(true)
            }
            
        })

    }
    
    

   

}
