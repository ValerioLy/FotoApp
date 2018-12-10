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
    
    private var selectedImage : Photo?
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
        
        // large title
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // Navigation stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let img = selectedImage, let identifier = segue.identifier, identifier == R.segue.albumItemController.segueToFullImage.identifier  {
            if let destination = segue.destination as? FullImageViewerController {
                destination.imageToShow = img
            }
        }
    }
}

extension AlbumItemController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    enum Actions : Int {
        case AddPhoto = 0
        case OpenChat
    }
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
            
            if indexPath.row == Actions.AddPhoto.rawValue {
                actionCell.setup(actionNameStr: "Aggiungi foto")
            }
            else if indexPath.row == Actions.OpenChat.rawValue {
                actionCell.setup(actionNameStr: "Apri chat")
            }
            
            return actionCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            self.selectedImage = album[indexPath.row]
            self.performSegue(withIdentifier: R.segue.albumItemController.segueToFullImage, sender: self)
        case 1:
            if indexPath.row == Actions.AddPhoto.rawValue {
//                self.performSegue(withIdentifier: "", sender: self)
            }
            else if indexPath.row == Actions.OpenChat.rawValue {
//                self.performSegue(withIdentifier: "", sender: self)
            }
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch indexPath.section {
        case 0:
            return calcolateSizeOfImage(frameWidth: self.collectionView.frame.width, indexPath: indexPath)
        case 1:
            return CGSize(width: self.collectionView.frame.width, height: 48.0)
        default:
            return CGSize(width: 0.0, height: 0.0)
        }
    }
    
    private func calcolateSizeOfImage(frameWidth : CGFloat, indexPath : IndexPath) -> CGSize {
        let width = frameWidth / 2 - 32
        let heightForPortrait = (width * 7) / 6
        let heightForLandscape = (width * 6) / 7
        
        let row = (indexPath.row + 1) / 2
        if row % 2 == 0 {
            return CGSize(width: width, height: CGFloat(heightForPortrait))
        }
        else {
            return CGSize(width: width, height: CGFloat(heightForLandscape))
        }
    }

}
