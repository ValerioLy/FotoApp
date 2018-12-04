//
//  JobItemController.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit
import FirebaseFirestore

class AlbumItemController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let album : [Photo] = [
        Photo(id: "randomId", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543896870-78e77bd02034?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80"),
        Photo(id: "randomId2", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543866282-7205a4b88f09?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"),
        Photo(id: "randomId3", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543882892-98c7e865c7b8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"),
        Photo(id: "randomId", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543896870-78e77bd02034?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80"),
        Photo(id: "randomId2", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543866282-7205a4b88f09?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"),
        Photo(id: "randomId3", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543882892-98c7e865c7b8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"),
        Photo(id: "randomId", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543896870-78e77bd02034?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80"),
        Photo(id: "randomId2", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543866282-7205a4b88f09?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"),
        Photo(id: "randomId3", author: "randomIdAuthor", date: Timestamp().dateValue(), link: "https://images.unsplash.com/photo-1543882892-98c7e865c7b8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension AlbumItemController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (album.count != 0) ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return album.count
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            let imageCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellController.kIdentifier, for: indexPath) as! ImageCellController
            imageCell.setup(with: album[indexPath.row])
            return imageCell
        case 1:
            let actionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleLineActionController.kIdentifier, for: indexPath) as! SingleLineActionController
            actionCell.setup(actionNameStr: "Action name here")
            return actionCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch indexPath.section {
        case 0:
            return CGSize(width: self.collectionView.frame.width / 2 - 32, height: 120.0)
        case 1:
            return CGSize(width: self.collectionView.frame.width, height: 48.0)
        default:
            return CGSize(width: 0.0, height: 0.0)
        }
    }

}
