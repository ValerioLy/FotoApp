//
//  UserInfoController.swift
//  FotoApp
//
//  Created by Valerio Ly on 30/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UserInfoController: UIViewController {

    enum TagFields : Int {
    case name = 0
    case surname
    case email
    }
    
    var user : User = User()
    private var pickerController:UIImagePickerController?
    var db: Firestore! = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let collection = "users"
    
    
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nasconde il back
         self.navigationItem.setHidesBackButton(true, animated:true)

    }
    
    
    
  
    
    
    @IBOutlet weak var lblContinue: UIBarButtonItem!{
        didSet {
            lblContinue.title = R.string.localizable.lblUserInfoContinue()
        }
    }
    
    @IBOutlet weak var lblInfo: UILabel! {
        didSet {
            lblInfo.text = R.string.localizable.lblUserInfoinfo()
        }
    }
    
    @IBOutlet weak var picture: UIButton! {
        didSet {
            picture.Circle()
            
        }
    }
    
    @IBOutlet weak var lblAdmin: UILabel! {
        didSet {
            lblAdmin.text = R.string.localizable.lblUserInfoAdmin()
        }
    }
    
    
    
    @IBOutlet var labelFields: [UILabel]! {
        didSet {
        for labels in labelFields {
            switch labels.tag {
            case TagFields.name.rawValue:
                labels.text = R.string.localizable.lblUserInfoName()
            case TagFields.surname.rawValue:
                  labels.text = R.string.localizable.lblUserInfoSurname()
            case TagFields.email.rawValue:
                  labels.text = R.string.localizable.lblUserInfoEmail()
            default : break
            }
        }
        }
    }
    
    @IBOutlet var textFields: [UITextField]!
        {
        didSet {
            for placeholders in textFields {
                switch placeholders.tag {
                case TagFields.name.rawValue:
                    placeholders.placeholder = R.string.localizable.textFieldUserInfoName()
                case TagFields.surname.rawValue:
                    placeholders.placeholder = R.string.localizable.textFieldUserInfoSurname()
                default : break
                }
            }
        }
    }
    
    
    @IBAction func addPictureProfile(_ sender: Any) {
        self.pickerController = UIImagePickerController()
        self.pickerController!.delegate = self
        self.pickerController!.allowsEditing = true
        
        
        let alert = UIAlertController(title: nil, message: "Foto profilo", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Annulla", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        #if !targetEnvironment(simulator)
        let photo = UIAlertAction(title: "Scatta foto", style: .default) { action in
            self.pickerController!.sourceType = .camera
            self.present(self.pickerController!, animated: true, completion: nil)
        }
        alert.addAction(photo)
        #endif
        
        let camera = UIAlertAction(title: "Carica foto", style: .default) { alert in
            self.pickerController!.sourceType = .photoLibrary
            self.present(self.pickerController!, animated: true, completion: nil)
        }
        alert.addAction(camera)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func ChooseUser(_ sender: UISwitch) {
        if sender.isOn {
//            self.performSegue(withIdentifier: "", sender: self)
        } else {
//            self.performSegue(withIdentifier: "", sender: self)
        }
    }
    
    
    @IBAction func ContinueAction(_ sender: UIBarButtonItem) {
        // prende il testo delle textfield
        var name : String? = ""
        var surname : String? = ""
        var email : String? = ""
        
        for textField in textFields {
            switch textField.tag {
            case TagFields.name.rawValue :
                
                name = textField.text
                break
            case TagFields.surname.rawValue :
                
                surname = textField.text
                break
            case TagFields.email.rawValue :
               
                email = textField.text
                break
            default : break
            }
        }
      
       
        pushUserData(name: name, surname: surname, email: email, image: image) { (success) in
            if success {
          print("caricato l'utente e l'immagine")
              self.performSegue(withIdentifier: "segueTerms", sender: self)
            }
            else {
                print("non va un cazzo")
            }
        }
    }
        
        
        


//        guard let user = Auth.auth().currentUser else { return}
//
//        db.collection(self.collection).document(user.uid).setData(["name" : name, "surname" : surname, "email": email, "image": image], merge: true, completion: { (error) in
//
//                if let err = error{
//                    let alert = UIAlertController(title: "OPS", message: err.localizedDescription, preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
//                    print("User could not be saved: \(err).")
//                }
//                else {
//                    print("User saved successfully!")
//                    self.performSegue(withIdentifier: "segueTerms", sender: self)
//                }
//            })
    
    
    
    func pushUserData(name: String? = nil, surname: String? = nil, email: String? = nil, image : UIImage? = nil, completion: @escaping(Bool) -> ()){
        
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
            
        }
        
        if let userImage = image {
            
            let folderRef = storageRef.child("\(user.uid)/profile-pic.jpg")
            _ = folderRef.putData(userImage.pngData() ?? Data(), metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    completion(false)
                    debugPrint("metadata nullo")
                    return
                }
                folderRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        completion(false)
                        debugPrint("downloadurl nullo")
                        return
                    }
                    
                    self.db.collection(self.collection).document(user.uid).setData([
                        "id":user.uid,
                        "name": name ,
                        "surname": surname ,
                        "email": email ,
                        "image": downloadURL.absoluteString
                    ], merge: true) { error in
                        if let error = error {
                            completion(false)
                            print("errore caricamento dati")
                        } else {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    
    
}


extension UserInfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage  else {
            debugPrint("No image found")
            return
        }
        
        
        self.image = checkImageSizeAndResize(image: image)
        
        self.picture.setImage(self.image, for: .normal )
        
//
//        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
//            let imgName = imgUrl.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//            let localPath = documentDirectory?.appending(imgName)
//
//            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            let data = image.pngData()! as NSData
//            data.write(toFile: localPath!, atomically: true)
//
//            let photoURL = URL.init(fileURLWithPath: localPath!)
//            print(photoURL)
//            self.urlText.text = photoURL.absoluteString
//
//        }
//
  
       
    
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    private func checkImageSizeAndResize(image : UIImage) -> UIImage {
        
        let imageSize: Int = image.pngData()!.count
        let imageDimension = Double(imageSize) / 1024.0 / 1024.0
        print("size of image in MB: ", imageDimension)
        
        if imageDimension > 15 {
            
            let img = image.resized(withPercentage: 0.5) ?? UIImage()
            
            
            return checkImageSizeAndResize(image: img)
            
        }
        
        return image
        
        
    }
}


