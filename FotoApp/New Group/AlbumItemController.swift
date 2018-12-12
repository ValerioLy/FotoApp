//
//  JobItemController.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit
import FirebaseFirestore

class AlbumItemController: UIViewController {
    private var pickerController:UIImagePickerController?
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var currentAlbum : Album!
    private var selectedImage : Photo?
    private var photos : [Photo] = []
    private var realtimeListener : ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // load local data
//        self.title = self.currentAlbum.title
//        self.photos = Photo.getObjects(withId: Array(self.currentAlbum.photos))
        
        // create the listener
        realtimeListener = NetworkManager.getAlbumListener(albumId: "NiMdU2biSSPgHV65bzL8")
        
        // Add the notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "photoListener"), object: nil)
    }
    
    @objc private func notificationObserver(notification : Notification) {
        self.currentAlbum = Album.getObject(withId: "NiMdU2biSSPgHV65bzL8")
        self.title = self.currentAlbum.title
        
        let ids = Array(self.currentAlbum!.photos)
        NetworkManager.fetchAlbums(ids: ids, completion: { (success, err) in
            if success {
                self.photos = Photo.getObjects(withId: ids)
                self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func openPickerDialog() {
        self.pickerController = UIImagePickerController()
        self.pickerController!.delegate = self
        self.pickerController!.allowsEditing = true
        
        let alert = UIAlertController(title: "Add photo", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        #if !targetEnvironment(simulator)
        let photo = UIAlertAction(title: "Take photo", style: .default) { action in
            self.pickerController!.sourceType = .camera
            self.present(self.pickerController!, animated: true, completion: nil)
        }
        alert.addAction(photo)
        #endif
        
        let camera = UIAlertAction(title: "Upload foto", style: .default) { alert in
            self.pickerController!.sourceType = .photoLibrary
            self.present(self.pickerController!, animated: true, completion: nil)
        }
        alert.addAction(camera)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Navigation stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let img = selectedImage, let identifier = segue.identifier, identifier == R.segue.albumItemController.segueToFullImage.identifier  {
            if let destination = segue.destination as? FullImageViewerController {
                destination.imageToShow = img
            }
        }
        else if segue.identifier == R.segue.albumItemController.segueToDetails.identifier {
            if let destination = segue.destination as? AlbumItemDetailsController {
                destination.currentAlbum = self.currentAlbum
            }
        }
    }
}

extension AlbumItemController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    enum Actions : Int {
        case AddPhoto = 0
        case OpenChat
        case ViewDetails
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return photos.count
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            let imageCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellController.kIdentifier, for: indexPath) as! ImageCellController
            imageCell.setup(with: photos[indexPath.row])
            return imageCell
        case 1:
            let actionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleLineActionController.kIdentifier, for: indexPath) as! SingleLineActionController
            
            if indexPath.row == Actions.AddPhoto.rawValue {
                actionCell.setup(actionNameStr: "Aggiungi foto")
            }
            else if indexPath.row == Actions.OpenChat.rawValue {
                actionCell.setup(actionNameStr: "Apri chat")
            }
            else if indexPath.row == Actions.ViewDetails.rawValue {
                actionCell.setup(actionNameStr: "Vedi dettagli")
            }
            
            return actionCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            self.selectedImage = photos[indexPath.row]
            self.performSegue(withIdentifier: R.segue.albumItemController.segueToFullImage, sender: self)
        case 1:
            if indexPath.row == Actions.AddPhoto.rawValue {
                self.openPickerDialog()
            }
            else if indexPath.row == Actions.OpenChat.rawValue {
//                self.performSegue(withIdentifier: "", sender: self)
            }
            else if indexPath.row == Actions.ViewDetails.rawValue {
                self.performSegue(withIdentifier: R.segue.albumItemController.segueToDetails.identifier, sender: self)
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
            return CGSize(width: self.collectionView.frame.width, height: 56.0)
        default:
            return CGSize(width: 0.0, height: 0.0)
        }
    }
    
    private func calcolateSizeOfImage(frameWidth : CGFloat, indexPath : IndexPath) -> CGSize {
        let width = frameWidth / 2 - 12
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

// Photo picker implements
extension AlbumItemController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            debugPrint("No image found")
            return
        }
        
        let img = checkImageSizeAndResize(image: image)
        self.dismiss(animated: true, completion: nil)
        
        // show loading alert view
        let loadingAlert = UIApplication.loadingAlert(title: "Loading")
        self.present(loadingAlert, animated: true, completion: nil)
        
        NetworkManager.uploadPhoto(image: img, albumId: self.currentAlbum.id) { (success, err) in
            if success {
                loadingAlert.dismiss(animated: true, completion: nil)
            }
            else {
                let alert = UIApplication.alertError(title: "Error", message: "Problems during uploading", closeAction: {})
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func checkImageSizeAndResize(image : UIImage) -> UIImage {
        let imageSize: Int = image.pngData()!.count
        let imageDimension = Double(imageSize) / 1024.0 / 1024.0
        
        if imageDimension > 2 {
            let img = image.resized(withPercentage: 0.5) ?? UIImage()
            return checkImageSizeAndResize(image: img)
        }
        
        return image
    }
    
}
