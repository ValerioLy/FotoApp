//
//  JobDetailsViewController.swift
//  FotoApp
//
//  Created by Alessio Lasta on 04/12/2018.
//

import UIKit

class JobDetailsViewController: UIViewController {
    @IBOutlet weak var titleTopic: UINavigationItem!
    
    private var trueListAlbum : [Album] = []
    private var trueTopic : Topic!
    private var selectedAlbumId : String?
    
    var id = ""
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getTopicsJobDetail(id: id){ (success, topic) in
            if success {
                self.trueTopic = topic!
                self.title = self.trueTopic.title
                
                let ids = Array(self.trueTopic.albums)
                NetworkManager.getAlbums(ids: ids, completion: { (success, err) in
                    if success {
                        
                        // take from realm
                        ids.forEach({ (item) in
                            let albumFound = Album.getObject(withId: item)
                            
                            if albumFound != nil {
                                self.trueListAlbum.append(albumFound!)
                            }
                        })
                        
                        // reload table
                        self.table.reloadSections(IndexSet(arrayLiteral: 0,1), with: .automatic)
                    }
                })
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAlbumSpecs" {
            if let destination = segue.destination as? AlbumItemController,
                let id = self.selectedAlbumId {
                destination.albumId = id
            }
        }
    }
}



extension JobDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.trueListAlbum.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.kIdentifier, for: indexPath) as! TopicTableViewCell
            cell.desc.text = trueTopic?.descriptio ?? ""
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicAlbumsTableViewCell.kIdentifier, for: indexPath) as! TopicAlbumsTableViewCell
            
            cell.title.text = self.trueListAlbum[indexPath.row].title
            cell.photos.text = String(self.trueListAlbum[indexPath.row].photos.count) + " photos"
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAlbumId = self.trueListAlbum[indexPath.row].id
        self.performSegue(withIdentifier: "segueToAlbumSpecs", sender: self)
    }
}


