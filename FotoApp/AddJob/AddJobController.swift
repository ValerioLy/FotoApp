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
    
    var filterData = [Users]()
    
    var isSearching = false
   
    var iniziali : [String]! = []
    var sectionToReload : [Int]! = []
    
    var numContactSection : [Int] = []
    
    //var listUsers2 : [Users]
    var rows : Int = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.getData(){ (list) in
            self.listUsers = list
            self.listUsers = self.listUsers.sorted(by: { $0.getName().lowercased() < $1.getName().lowercased() })
            //self.listUsers2 = self.listUsers
            /*for i in 0..<self.iniziali.count {
                
           
            self.sectionToReload.append(i)
            }
            let indexSet: IndexSet = IndexSet(self.sectionToReload)
            self.tableView.insertSections(indexSet, with: .automatic)*/
            self.tableView.reloadData()
//            let sectionToReload = self.iniziali.count
//            let indexSet: IndexSet = [sectionToReload]
//            self.tableView.reloadSections(indexSet, with: .automatic)
        
            
        }
    
    }
       
    
    
    @IBAction func descriptionSegue(_ sender: Any) {
   self.performSegue(withIdentifier: "segueAddJob", sender: self)
    }
    
    

   
}

extension AddJobController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var carattere : String = ""
        var successivo : String
        for user in self.listUsers{
            successivo = user.name!.prefix(1).uppercased()
            if carattere != successivo && successivo != ""{
                carattere = successivo
                iniziali.append(carattere)
                numContactSection.append(1)
                NSLog("numberOfSections carattere: "+carattere)
                
            }
            else{
                numContactSection[numContactSection.count-1]+=1
                NSLog("numberOfSections numcontactSection: "+String(numContactSection[numContactSection.count-1]))
            }
        }
        self.rows = 0
        return iniziali.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterData.count
        }
        return numContactSection[section]
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCell
        
       
        
        if isSearching {
           cell.name.text = filterData[indexPath.row].name
            cell.surname.text = filterData[indexPath.row].surname

            
        } else if (self.rows < listUsers.count)
        {
            
            cell.name.text = listUsers[self.rows].name

            cell.surname.text = listUsers[self.rows].surname
            self.rows += 1
        }
        
      
        return cell
    }
  
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = listUsers.filter({$0.name!.prefix(searchText.count).lowercased() == searchBar.text?.lowercased() || $0.surname!.prefix(searchText.count).lowercased() == searchBar.text?.lowercased() })
        isSearching = true
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return iniziali[section]
    }
    
    
}
