//
//  ViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 03/12/2018.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase

class OptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutAction(_ sender: Any) {
        NetworkManager.logout { (success) in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource {
    enum OptionsItem : Int {
        case UserInfo = 0
        case Credits
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleLineActionCell.kIdentifier) as! SingleLineActionCell
        
        switch indexPath.row {
        case OptionsItem.UserInfo.rawValue:
            cell.setup(actionName: "Informazioni utente")
        case OptionsItem.Credits.rawValue:
            cell.setup(actionName: "Crediti")
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case OptionsItem.UserInfo.rawValue:
            self.performSegue(withIdentifier: "toInfoSegue", sender: nil)
        case OptionsItem.Credits.rawValue:
            self.performSegue(withIdentifier: "toCreditSegue", sender: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
