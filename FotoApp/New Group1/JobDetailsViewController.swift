//
//  JobDetailsViewController.swift
//  FotoApp
//
//  Created by Alessio Lasta on 04/12/2018.
//

import UIKit
import Firebase

class JobDetailsViewController: UIViewController {
    @IBOutlet weak var titleTopic: UINavigationItem!
    @IBOutlet weak var buttonAdd: UIButton! {
        didSet {
            buttonAdd.circle()
        }
    }
    
    private var trueListAlbum : [Album] = []
    private var trueTopic : Topic!
    private var selectedAlbumId : String?
    private var listeners : [ListenerRegistration?]?
    
    var id = ""
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the button if admin si logged
        if let user = User.getObject(withId: NetworkManager.getUserId()) {
            buttonAdd.isHidden = user.admin
        }
        
        self.trueTopic = Topic.getObject(withId: id)
        self.title = self.trueTopic.title
        self.trueListAlbum = Album.getObject(forTopic: id)
        
        listeners = NetworkManager.getTopicListeners(idTopic: id)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "albumsListener"), object: nil)
    }
    
    @objc private func notificationObserver(notification : Notification) {
        self.trueTopic = Topic.getObject(withId: id)
        self.title = self.trueTopic.title
        self.trueListAlbum = Album.getObject(forTopic: self.trueTopic.id)
        
        self.table.reloadSections(IndexSet(arrayLiteral: 0, 1), with: .automatic)
    }
    
    deinit {
        // clear the listeners
        listeners?.forEach({ (item) in
            item?.remove()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAlbumSpecs" {
            if let destination = segue.destination as? AlbumItemController,
                let id = self.selectedAlbumId {
                destination.albumId = id
            }
        }
        else if segue.identifier == "segueToAddAlbum" {
            if let destination = segue.destination as? AddAlbumController {
                destination.topicId = self.id
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
        guard indexPath.section != 0 else {
            return
        }
        
        self.selectedAlbumId = self.trueListAlbum[indexPath.row].id
        self.performSegue(withIdentifier: "segueToAlbumSpecs", sender: self)
    }
}


