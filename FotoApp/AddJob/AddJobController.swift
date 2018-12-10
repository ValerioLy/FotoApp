//
//  AddJobController.swift
//  FotoApp
//
//  Created by Valerio Ly on 04/12/18.
//

import UIKit

class AddJobController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    
    @IBOutlet weak var addjobTitle: UILabel!
    
    @IBOutlet weak var clicktoselectmultipleworkers: UILabel!
    
    
   
    
    var listUsers : [Users] = []
    
    var filterData = [Users]()

    var isSearching = false

    var iniziali : [String] = []


 

    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.getData(){ (list) in
            self.listUsers = list
            self.listUsers = self.listUsers.sorted(by: { $0.getName().lowercased() < $1.getName().lowercased() })
     
            self.tableView.reloadData()

        
            
        }
    
    }
       
    
    
    @IBAction func descriptionSegue(_ sender: Any) {
   self.performSegue(withIdentifier: "segueAddJob", sender: self)
    }
    
    

   
}

extension AddJobController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if isSearching {
            return filterData.count
        }
        return listUsers.count
        
       
       
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCell


        if isSearching{
            cell.name.text = filterData[indexPath.row].fullName()
        }
        else{
            cell.name.text = listUsers[indexPath.row].fullName()
           
        }
      

        return cell
      
    }
  
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = listUsers.filter({$0.fullName().prefix(searchText.count).lowercased() == searchBar.text?.lowercased() })
        isSearching = true
        tableView.reloadData()
    }

 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        }
    }
    

    
    
}
