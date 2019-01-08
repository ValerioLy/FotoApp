//
//  JobsListViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 04/12/2018.
//

import UIKit
import Firebase
import FirebaseFirestore
import RealmSwift

class JobsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var listOfTopic : [Topic] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonOutlet: UIButton! {
        didSet {
            buttonOutlet.circle()
        }
    }
    
    var imagesArray: [String] = []
    var filterData = [Topic]()
    private var selectedJobId : String? = nil
    var isSearching = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        
        var currentUser : User = User()
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.buttonOutlet.isHidden = true
        
        // update user info
        NetworkManager.getUserData { (success, err) in
            if success {
                currentUser = User.getObject(withId: Auth.auth().currentUser!.uid)!
                if currentUser.admin {
                    self.buttonOutlet.isHidden = false
                }
                NetworkManager.getTopics()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "topicListener"), object: nil)       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            if let destination = segue.destination as? JobDetailsViewController,
                let id = selectedJobId {
                destination.id = id
            }
        }
    }

    @objc private func notificationObserver(notification : Notification) {
        self.listOfTopic = Topic.all().sorted(by: { $0.getTitle().lowercased() < $1.getTitle().lowercased() })
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    // Manage navbar
    func setupNavbar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearching {
            return filterData.count
        }
        return listOfTopic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsCell", for: indexPath) as! JobsCell

        
        if isSearching{
            cell.missionName.text = filterData[indexPath.row].title
            cell.missionDate.text = filterData[indexPath.row].creation.date?.stringFormatted
        }
        else{
            cell.missionName.text = listOfTopic[indexPath.row].title
            cell.missionDate.text = listOfTopic[indexPath.row].creation.date?.stringFormatted
            
            
            NetworkManager.getImageData { (success, urlString) in
                let checkedUrl = URL(string: urlString)
                
                if success {
                    cell.downloadImage(url: checkedUrl!)
                }
            }

            
          
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedJobId = self.listOfTopic[indexPath.row].id
        self.performSegue(withIdentifier: "segueToDetails", sender: self)
    }    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = self.listOfTopic.filter({$0.getTitle().prefix(searchText.count).lowercased() == searchBar.text?.lowercased() })
        isSearching = true
        tableView.reloadData()
    }
    

    
    
   
}
