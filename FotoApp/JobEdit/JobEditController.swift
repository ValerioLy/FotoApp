//
//  JobEditController.swift
//  FotoApp
//
//  Created by Valerio Ly on 09/01/19.
//

import UIKit

class JobEditController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var editBool : Bool = false
    var topicId = ""
    
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
            editBool = true
            UIApplication.reloadGenericViewController(storyboardName: "AddJob", controllerIdentifier: "addjob")
        break
        case 1:
            editBool = true
            print("da edit a addjob :"+topicId)
          self.performSegue(withIdentifier: "segueAddJob", sender: self)
        default : break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        switch segue.identifier {
        case "segueAddJob":
            if let destinationController = segue.destination as? AddJobController {
                destinationController.isEdit = editBool
                destinationController.id = topicId
            }
            
            if let destinationController = segue.destination as? AddMissioneController{
                destinationController.edit = editBool
            }
        default:
            break
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

   

}
