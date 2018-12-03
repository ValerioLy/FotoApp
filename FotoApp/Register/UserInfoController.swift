//
//  UserInfoController.swift
//  FotoApp
//
//  Created by Valerio Ly on 30/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserInfoController: UIViewController {

    enum TagFields : Int {
    case name = 0
    case surname
    case email
    }
    
    var user : User = User()
    private var pickerController:UIImagePickerController?
    static var db: Firestore! = Firestore.firestore()
    let collection = "listaUtenti"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Nasconde il back
         self.navigationItem.setHidesBackButton(true, animated:true)
        
        if let utente = Auth.auth().currentUser {
            var textEmail = utente.email
             self.emailField.text = textEmail
            debugPrint("Email Riportata")
        } else {
            debugPrint("Email Non Riportata")
        }
        
        
      
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var urlText: UITextField!
    
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
            picture.Circle(button: picture)
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
                case TagFields.email.rawValue:
                    placeholders.placeholder = R.string.localizable.textFieldUserInfoEmail()
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
    
    
    
    
    @IBAction func ContinueAction(_ sender: UIBarButtonItem) {
        
        // prende il testo delle textfield
        var name : String? = ""
        var surname : String? = ""
        var email : String? = ""
        var image : String? = ""
        
        for textField in textFields {
            switch textField.tag {
            case TagFields.name.rawValue :
                user.nome = textField.text
                name = textField.text
                break
            case TagFields.surname.rawValue :
                user.cognome = textField.text
                surname = textField.text
                break
            case TagFields.email.rawValue :
                user.email = textField.text
                email = textField.text
                break
            default : break
            }
        }
        
        
        user.image = urlText.text
        image = urlText.text
        user.save()
        
      
      
        // sava i dati nel server
        
        guard let user = Auth.auth().currentUser else { return}
            
        UserInfoController.db.collection(self.collection).document(user.uid).setData(["name" : name, "surname" : surname, "email": email, "image": image], merge: true, completion: { (error) in
                
                if let err = error{
                    let alert = UIAlertController(title: "OPS", message: err.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    print("User could not be saved: \(err).")
                }
                else {
                    print("User saved successfully!")
                    self.performSegue(withIdentifier: "segueTerms", sender: self)
                }
            })
    }
    
    
    
}


extension UserInfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage  else {
            debugPrint("No image found")
            return
        }
        
        
        let img2 = checkImageSizeAndResize(image: image)
        
        self.picture.setImage(img2, for: .normal )
        

        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)

            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)

            let photoURL = URL.init(fileURLWithPath: localPath!)
            print(photoURL)
            self.urlText.text = photoURL.absoluteString
            
        
           
            let storageRef = Storage.storage().reference(withPath: photoURL.absoluteString)
                let uploadData = StorageMetadata()
                uploadData.contentType = "image/jpeg"
                storageRef.putFile(from: photoURL as URL, metadata: uploadData) { (StorageMetadata, Error) in
                    if (Error != nil){
                        print("error \(Error?.localizedDescription)")
                    } else {
                        print ("upload complete \(StorageMetadata)")
                    }
                }
            
        }
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

