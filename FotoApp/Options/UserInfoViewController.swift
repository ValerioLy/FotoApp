//
//  UserInfoViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 03/12/2018.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.circle()
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSurname: UILabel!
    @IBOutlet weak var userAdmin: UISwitch!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let user = User.getObject(withId: NetworkManager.getUserId()) else {
            return
        }
        
        self.title = "Informazioni utente"
        
        NetworkImageManager.image(with: user.id,from: user.image ?? "") { (imageData, success) in
            DispatchQueue.main.async {
                if success {
                    self.userImage.image = UIImage(data: imageData!)
                }
            }
        }
        
        userName.text = user.name
        userSurname.text = user.surname
        userAdmin.isOn = user.admin
        userEmail.text = user.email
    }
}
