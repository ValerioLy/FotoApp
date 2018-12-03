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
    
    
    private var ref: DocumentReference!
    private var db: Firestore!
    private let collection = "listaUtenti"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        self.initFirebase()
        //self.navigationController.navigationbar.sizeThatFit
        // Do any additional setup after loading the view.
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
            self.present(alertError(title: "Failed Empty Labels Title", message: "Login Failed Empty Labels", closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard isValidEmail(email: email) else {
            self.present(alertError(title: "Login Failed Invalid Email", message: "Login Failed Invalid Email", closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard password.count > 5 else {
            self.present(alertError(title: "Login Failed Invalid Password", message: "Login Failed Invalid Password".localized, closeAction: {}),  animated: true, completion: nil)
            return
        }
        login(email: email, password: password) { (success) in
            if success {
                self.present(self.alertError(title: "Login Success", message: "Login success".localized, closeAction: {}),  animated: true, completion: nil)
                /*self.performSegue(withIdentifier: R.segue.loginController.segueToMain, sender: self)*/
            }
        }
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
     //self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
     self.navigationController?.navigationBar.sizeThatFits(CGSize()
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension LoginViewController{
    

    
    
    func initFirebase() {
        FirebaseApp.configure()
        
        
        db = Firestore.firestore()
        
        
        
    }
    
    func isValidEmail(email : String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func login(email:String, password: String, completion: @escaping (Bool)->())
    {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            guard let user = user else {
                self.topViewController()?.present(self.alertError(title: "Error", message: error?.localizedDescription, closeAction: {completion(false)}),animated: true, completion: nil)
                return
            }
            debugPrint(user)
            completion(true)
        }
        
        
    }
    

    
    
    func alertError(title: String?, message: String?, closeAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        return alert
    }
    
    func reloadGenericViewController(storyboardName : String, controllerIdentifier: String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let setViewController = mainStoryboard.instantiateViewController(withIdentifier: controllerIdentifier)
        let rootViewController = UIApplication.shared.windows.last?.rootViewController
        rootViewController?.present(setViewController, animated: true, completion: nil)
    }
    
    
    
}
