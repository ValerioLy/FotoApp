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
    @IBOutlet weak var metadataContainer: UIView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var metaDate: UILabel!
    @IBOutlet weak var metaUser: UILabel!
    
    var albumId : String!
    private var isMetadataHidden : Bool = false
    private var currentAlbum : Album!
    private var selectedImage : Photo?
    private var photos : [Photo] = []
    private var realtimeListener : ListenerRegistration?
    
    // full screen image variables
    private var selectedX : CGFloat?
    private var selectedY : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide metadata
        self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: self.metadataContainer.bounds.height)
        
        // add the image to the view
        self.fullImageView.isUserInteractionEnabled = true
        self.fullImageView.backgroundColor = UIColor.white
        self.fullImageView.contentMode = .scaleAspectFit
        self.fullImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        // zoom and tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreen(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
        self.fullImageView.addGestureRecognizer(tapGesture)
        self.fullImageView.addGestureRecognizer(pinchGesture)
        
        // load local data
        self.currentAlbum = Album.getObject(withId: albumId)
        if self.currentAlbum != nil {
            self.title = self.currentAlbum.title
            self.photos = Photo.getObjects(withId: Array(self.currentAlbum.photos))
        }
        
        // create the listener
        realtimeListener = NetworkManager.getAlbumListener(albumId: albumId)
        
        // Add the notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserver(notification:)), name: NSNotification.Name(rawValue: "photoListener"), object: nil)
    }
    
    @objc private func notificationObserver(notification : Notification) {
        self.currentAlbum = Album.getObject(withId: albumId)
        self.title = self.currentAlbum.title
        
        let ids = Array(self.currentAlbum!.photos)
        NetworkManager.fetchPhotos(ids: ids, completion: { (success, err) in
            if success {
                self.photos = Photo.getObjects(withId: ids)
                self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
            }
        })
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
        if segue.identifier == R.segue.albumItemController.segueToDetails.identifier {
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
            if let selectedCell = self.collectionView.cellForItem(at: indexPath) {
                self.selectedX = selectedCell.frame.origin.x + (selectedCell.frame.width / 2)
                self.selectedY = selectedCell.frame.origin.y + (selectedCell.frame.width / 2)
                
                debugPrint(self.selectedY)
                debugPrint(selectedCell.frame.origin.y)
                
                openFullScreen()
            }
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

extension AlbumItemController {
    
    func openFullScreen() {
        NetworkImageManager.image(with: selectedImage!.id, from: selectedImage!.link) { (data, success) in
            if success {
                DispatchQueue.main.async {
                    // set initial bounds of the image
                    self.fullImageView.image = UIImage(data: data!)
                    self.fullImageView.contentMode = .scaleAspectFit
                    self.fullImageView.frame = CGRect(x: self.selectedX ?? 0, y: self.selectedY ?? 0, width: 0, height:0)
                    
                    // show metadata
                    if let imageDate = self.selectedImage?.date.date {
                        self.metaDate.text = imageDate.stringFormatted
                    }
                    else {
                        self.metaDate.text = "Informazione non disponibile"
                    }
                    self.metaUser.text = self.selectedImage?.authorName
                    
                    // animate the view to full screen
                    UIView.animate(withDuration: 0.3, animations: {
                        self.fullImageView.backgroundColor = UIColor.white
                        self.fullImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.isMetadataHidden = false
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        // hide navigation bar
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                    })
                }
            }
        }
    }
    
    @objc func dismissFullScreen(_ sender : UITapGestureRecognizer) {
        if isMetadataHidden {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.fullImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isMetadataHidden = false
            }
        }
        else {
            // reset all
            UIView.animate(withDuration: 0.3, animations: {
                // show navigation bar
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                self.fullImageView.backgroundColor = UIColor.clear
                self.fullImageView.frame = CGRect(x: self.selectedX ?? 0, y: self.selectedY ?? 0, width: 0, height: 0)
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: self.metadataContainer.frame.height)
                self.isMetadataHidden = false
            })
        }
    }
    
    @objc func zoomImage(_ sender : UIPinchGestureRecognizer) {
        guard sender.scale <= 1.5, let scale = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else { return }
        sender.view?.transform = scale
        
        if sender.scale <= 1 && isMetadataHidden {
            //slide up the view
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isMetadataHidden = false
            }
        }
        else if !isMetadataHidden {
            // slide down the view
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: self.metadataContainer.frame.height)
                self.isMetadataHidden = true
            }
        }
        
        if let view = sender.view?.frame, view.width < UIScreen.main.bounds.width || view.height < UIScreen.main.bounds.height {
            sender.view?.frame = UIScreen.main.bounds
        }
    }
}
