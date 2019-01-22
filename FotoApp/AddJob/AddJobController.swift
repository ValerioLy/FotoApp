//
//  AddJobController.swift
//  FotoApp
//
//  Created by Valerio Ly on 04/12/18.
//

import UIKit

class AddJobController: UIViewController {
    
    var searchController : UISearchController?
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    @IBOutlet weak var addjobTitle: UILabel!
    @IBOutlet weak var clicktoselectmultipleworkers: UILabel!
    
    private var selectedEmployee : [User]?
    private var idUsers : [String] = []
    var listUsers : [User] = []
    var filterData : [User] = []
    var isSearching = false
    var isEdit : Bool = false
    var id = ""
    var topic : Topic?
    var idWorker : [String] = []
   

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         if isEdit == true {
            let btn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(actionSave))
        self.navigationItem.rightBarButtonItem  = btn
        topic = Topic.getObject(withId: id)
            for element in (topic?.workers)! {
                idWorker.append(element)
            }
            
     
        }
        
        
        // show back button
        self.navigationItem.setHidesBackButton(false, animated:true)
        
        // show search bar in navigation
        searchController = UISearchController(searchResultsController: nil)
        searchController?.delegate = self as? UISearchControllerDelegate
        searchController?.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        NetworkManager.getAllUsers() { (list, err) in
            
            if list != nil {
                self.listUsers = list!
                self.listUsers = self.listUsers.sorted(by: { $0.getName().lowercased() < $1.getName().lowercased() })
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            }
        }
        
        print("AddJob id: "+id)
    }
    
    @objc func actionSave() {
        
        NetworkManager.uploadTopics(idDoc: id, workers: idUsers) { (success) in
            if success {
                debugPrint("upload id workers")
            }
        }
    }
    
    
    @IBAction func goMission(_ sender: Any) {
        self.performSegue(withIdentifier: "segueMission", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "segueMission":
            if let destinationController = segue.destination as? AddMissioneController {
                destinationController.listaIdUsers = idUsers
            }
        default:
            break
        }
        
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
        
        let idExist = idWorker.contains(listUsers[indexPath.row].id)
 
        if idExist {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
          
        }
        else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
           
        }
        
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = listUsers.filter({$0.fullName().prefix(searchText.count).lowercased() == searchBar.text?.lowercased() })
        isSearching = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEmployee = listUsers[indexPath.row]
        let idExist = idUsers.filter({$0 == selectedEmployee.id}).first
        
        //        if idExist != nil{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        //            let indexRemove = idUsers.firstIndex(of: idExist!)!
        //            idUsers.remove(at: indexRemove)
        //        }
        //        else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        //            idUsers.append(selectedEmployee.id)
        //            print("IDUTENTI\(idUsers)")
        //        }
        
        if idExist == nil{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            idUsers.append(selectedEmployee.id)
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            let indexRemove = idUsers.firstIndex(of: idExist!)!
            idUsers.remove(at: indexRemove)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}
