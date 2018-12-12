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
    var listOfAlbum : [Album] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonOutlet: UIButton!
//    private var db: Firestore! = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide back button
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // update user info
        NetworkManager.getUserData { (success, err) in
            if !success {
                debugPrint("Erro saving user info: \(err)")
            }
        }
        
        setupNavbar()
        
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
