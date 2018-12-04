//
//  AddJobController.swift
//  FotoApp
//
//  Created by Valerio Ly on 04/12/18.
//

import UIKit

class AddJobController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var listUsers : [Users] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        NetworkManager.getData(){ (list) in
            self.listUsers = list
            self.tableView.reloadData()
        }
    }
       
    
    
    
    

   
}

extension AddJobController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCell
        cell.name.text = listUsers[indexPath.row].name
        cell.surname.text = listUsers[indexPath.row].surname
        return cell
    }
    
    
    
    
}
