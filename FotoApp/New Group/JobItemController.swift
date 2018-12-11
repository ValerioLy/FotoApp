//
//  JobItemController.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit

class AlbumItemController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension AlbumItemController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
