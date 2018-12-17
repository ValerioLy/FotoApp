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
    var listOfAlbum : [Album] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    
    var filterData = [Topic]()
    
    var isSearching = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser : User = User()
        
        listOfTopic.removeAll()
        // hide back button
        self.navigationItem.setHidesBackButton(true, animated:true)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // update user info
        NetworkManager.getUserData { (success, err) in
            if !success {
                debugPrint("Erro saving user info: \(err)")
            }
            else{
                currentUser = User.getObject(withId: Auth.auth().currentUser!.uid)!
                debugPrint(currentUser)
                if !currentUser.admin {
                    self.buttonOutlet.isHidden = true
                }
            }
        }
//        
//        setupNavbar()
        
        buttonOutlet.layer.cornerRadius = 32
        buttonOutlet.clipsToBounds = true
        
        NetworkManager.getTopics()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "topicListener"), object: nil)
        
//        for topic in listOfTopic {
//            NetworkManager.getRandomPhoto(topic: topic)
//        }
    }

    @IBAction func addAction(_ sender: Any) {
        
    }
    
    @objc private func notificationObserver(notification : Notification) {
        self.listOfTopic = Topic.all()
        self.listOfTopic = self.listOfTopic.sorted(by: { $0.getTitle().lowercased() < $1.getTitle().lowercased() })
        tableView.reloadData()
       
    }
    
    // Manage navbar
//    func setupNavbar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        let searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
//
//
//    }
    

    
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
            cell.missionDate.text = filterData[indexPath.row].creation
        }
        else{
            cell.missionName.text = listOfTopic[indexPath.row].title
            cell.missionDate.text = listOfTopic[indexPath.row].creation
            
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = self.listOfTopic.filter({$0.getTitle().prefix(searchText.count).lowercased() == searchBar.text?.lowercased() })
        isSearching = true
        tableView.reloadData()
    }
    

}
