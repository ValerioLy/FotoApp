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
        
        self.title = currentAlbum.title
    }

    @IBAction func daEliminareAction(_ sender: Any) {
        
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
