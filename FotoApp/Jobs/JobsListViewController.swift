//
//  JobsListViewController.swift
//  FotoApp
//
//  Created by Marco Cozza on 04/12/2018.
//

import UIKit
import Firebase
import FirebaseFirestore

class JobsListViewController: UIViewController {
    
    var listOfMission : [Mission] = [Mission(id: "85181", name: "fewvef", descriptio: "scvnwoidncw", date: "04/12/98", expiring: "15/07/54", creator: "Marco"), Mission(id: "5489422", name: "vcsduiweoewbw", descriptio: "cwncncownvwvn", date: "14/03/78", expiring: "09/11/44", creator: "vnewiohewoiv")]
    
    @IBOutlet weak var tableView: UITableView!
    
    private var db: Firestore! = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        inserisco i topic da Realm nel listOfMission
         
            scarico da firestore i topic legati all'utente e li inserisco
            nel listOfMission per poi sovvrascivere quelli che ho in Realm
         
         */
        
        

    }


     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfMission.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsCell", for: indexPath) as! JobsCell
        
        
        cell.missionName.text = listOfMission[indexPath.row].name
        cell.missionDate.text = listOfMission[indexPath.row].date
        
        
        return cell
    }



}
