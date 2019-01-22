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
    private var amIAdmin : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user info
        self.amIAdmin = User.getObject(withId: NetworkManager.getUserId())?.admin ?? false
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Attenzione", message: "Sei sicuro di archiviare?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { (action) in
            NetworkManager.deleteAlbum(album: self.currentAlbum) { (success, err) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    let alert = UIApplication.alertError(title: "Opss", message: err, closeAction: {})
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion:  nil)
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
        if !amIAdmin  {
            return 2
        }
        else if currentAlbum.isPendingForDeletion {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleDetailAlbumCell.kIdentifier) as! SingleDetailAlbumCell
            cell.setup(album: self.currentAlbum)
            return cell
        case 1:
            if amIAdmin {
                let cell = tableView.dequeueReusableCell(withIdentifier: AdminDeleteCell.kIdentifier) as! AdminDeleteCell
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UserDeleteCell.kIdentifier) as! UserDeleteCell
                cell.setup(isPending: self.currentAlbum.isPendingForDeletion)
                return cell
            }
            
        default:
            return UITableViewCell()
        }
        
    }
}
