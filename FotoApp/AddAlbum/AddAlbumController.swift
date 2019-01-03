//
//  AddAlbumController.swift
//  FotoApp
//
//  Created by Nicola on 11/12/18.
//

import UIKit

class AddAlbumController: UIViewController {
    @IBOutlet weak var albumTitle: UITextField!
    @IBOutlet weak var albumDescr: UITextView!
    
    var topicId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    @IBAction func addAction(_ sender: Any) {
        guard albumTitle.text != nil, !albumTitle.text!.isEmpty else {
            let alert = UIApplication.alertError(title: "Opss", message: "Title missing") {}
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // loading alert
        let loadingAlert = UIApplication.loadingAlert(title: "Uploading")
        self.present(loadingAlert, animated: true, completion: nil)
        
        
        // upload album
        NetworkManager.uploadAlbum(topicId: topicId, title: albumTitle.text!, descr: albumDescr.text) { (success, err) in
            // dismiss alert
            loadingAlert.dismiss(animated: true, completion: {
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    let alert = UIApplication.alertError(title: "Opss", message: err, closeAction: {})
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
