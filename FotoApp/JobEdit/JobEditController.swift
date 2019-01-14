//
//  JobEditController.swift
//  FotoApp
//
//  Created by Valerio Ly on 09/01/19.
//

import UIKit

class JobEditController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
             let cell =  tableView.dequeueReusableCell(withIdentifier: "editTopic", for: indexPath)
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "editUser", for: indexPath)
            return cell
        default : return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            UIApplication.reloadGenericViewController(storyboardName: "AddJob", controllerIdentifier: "addjob")
        break
        case 1:
          self.performSegue(withIdentifier: "segueAddJob", sender: self)
        default : break
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)
    }
    

   

}
