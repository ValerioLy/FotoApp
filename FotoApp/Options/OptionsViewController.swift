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
                GeneralUtils.share.reloadGenericViewController(storyboardName: "AuthScreen", controllerIdentifier: "AuthScreen")
                self.performSegue(withIdentifier: "authSegue", sender: nil)
            }
        }
    }
    
    @IBAction func creditsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreditSegue", sender: nil)
    }
    @IBAction func infoAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toInfoSegue", sender: nil)

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
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}
