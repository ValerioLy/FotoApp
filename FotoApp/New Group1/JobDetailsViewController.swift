//
//  JobDetailsViewController.swift
//  FotoApp
//
//  Created by Alessio Lasta on 04/12/2018.
//

import UIKit

class JobDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var titleTopic: UINavigationItem!
    
    static let totallyFakeList : [[String : String]] = [["title": "An Album", "photos": "11 photos"],["title": "Another Album", "photos": "7 photos"],["title": "Yet another Album", "photos": "19 photos"]]
    
    var trueListAlbum : [Album] = []
    var trueTopic : Topic?
    var stringaAlbums : [String] = []
    var titleAlbums : [String] = []
    var numPhotos : [Int] = []
    
    var id = "97fcedce-01fe-11e9-8eb2-f2801f1b9fd1" //da modificare
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        NetworkManager.getTopicsJobDetail(id: id){ (success, topic) in
            if success {
                self.trueTopic = topic!
                self.titleTopic.title = self.trueTopic?.title
                self.stringaAlbums = topic!.getAlbum()
                for idAlbum in self.stringaAlbums{
                    NetworkManager.getAlbumPhoto(id: idAlbum){(success, titleAlbum, numPhoto) in
                        if success {
                            self.titleAlbums.append(titleAlbum)
                            self.numPhotos.append(numPhoto)
                            
                            self.table.reloadData()
                        }
                    }
                }
                //debugPrint("lista.count: "+String(lista!.count))
                /*for topic in lista!{
                    debugPrint("Topic: "+topic.getTitle())
                    
                }*/
                
            }
        }
        self.table.reloadData()
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
        print("numberOfRowInSection: "+String(titleAlbums.count))
        return titleAlbums.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
        
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.kIdentifier, for: indexPath) as! TopicTableViewCell
            
          cell.desc.text = trueTopic?.descriptio ?? ""
           
            
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicAlbumsTableViewCell.kIdentifier, for: indexPath) as! TopicAlbumsTableViewCell
            
            cell.title.text = titleAlbums[indexPath.row - 1]
            cell.photos.text = String(numPhotos[indexPath.row - 1])//String(trueList[indexPath.row].getAlbum().count)
            
            return cell
            
        }
        
    
    }
    
    
}


