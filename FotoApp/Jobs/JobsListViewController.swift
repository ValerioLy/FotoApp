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

class JobsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listOfTopic : [Topic] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonOutlet: UIButton! {
        didSet {
            buttonOutlet.circle()
        }
    }
    private var db: Firestore! = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide back button
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        setupNavbar()
        
        buttonOutlet.layer.cornerRadius = 32
        buttonOutlet.clipsToBounds = true
        
        NetworkManager.getTopics()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "topicListener"), object: nil)
        
        
        /*
        buttonOutlet.frame = CGRect(x: 160, y: 100, width: 96, height: 96)
        buttonOutlet.layer.cornerRadius = 1
        buttonOutlet.clipsToBounds = true
        
        
         
        inserisco i topic da Realm nel listOfMission
         
            scarico da firestore i topic legati all'utente e li inserisco
            nel listOfMission per poi sovvrascivere quelli che ho in Realm
         
         */
        
        

    }

    @IBAction func addAction(_ sender: Any) {
        
    }
    
    @objc private func notificationObserver(notification : Notification) {
        self.listOfTopic = Topic.all()
        tableView.reloadData()
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
        return listOfTopic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsCell", for: indexPath) as! JobsCell
        
        
        cell.missionName.text = listOfTopic[indexPath.row].title
        cell.missionDate.text = listOfTopic[indexPath.row].creation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
