//
//  AlbumItemDetailsController.swift
//  FotoApp
//
//  Created by Nicola on 11/12/18.
//

import UIKit

class AlbumItemDetailsController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var currentAlbum : Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func daEliminareAction(_ sender: UISwitch) {
        
        NetworkManager.changePendingDeletionForAlbum(pending: sender.isOn, albumId: currentAlbum.id) { (success, err) in
            if !success {
                let alert = UIApplication.alertError(title: "Opss", message: err, closeAction: {})
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension AlbumItemDetailsController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleDetailAlbumCell.kIdentifier) as! SingleDetailAlbumCell
        cell.setup(album: self.currentAlbum)
        return cell
    }
}
