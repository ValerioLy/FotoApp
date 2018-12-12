//
//  JobDetailsViewController.swift
//  FotoApp
//
//  Created by Alessio Lasta on 04/12/2018.
//

import UIKit

class JobDetailsViewController: UIViewController {
    
    
    static let totallyFakeList : [[String : String]] = [["title": "An Album", "photos": "11 photos"],["title": "Another Album", "photos": "7 photos"],["title": "Yet another Album", "photos": "19 photos"]]
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}



extension JobDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return JobDetailsViewController.totallyFakeList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.kIdentifier, for: indexPath) as! TopicTableViewCell
            
            cell.desc.text = "A long desc"
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicAlbumsTableViewCell.kIdentifier, for: indexPath) as! TopicAlbumsTableViewCell
            
            cell.title.text = JobDetailsViewController.totallyFakeList[indexPath.row - 1]["title"]
            cell.photos.text = JobDetailsViewController.totallyFakeList[indexPath.row - 1]["photos"]
            
            return cell
            
        }
        
    
    }
    
    
}


