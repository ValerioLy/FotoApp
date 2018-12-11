//
//  UserInfoController.swift
//  FotoApp
//
//  Created by Valerio Ly on 30/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import UIKit

class UserInfoController: UIViewController {
    
    enum TagFields : Int {
        case name = 0
        case surname
    }
    private var pickerController:UIImagePickerController?
    
    var image : UIImage?
    var hasInsertedData : Bool = false
    var hasAcceptedContract : Bool = false
    var admin : Bool = false
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
            picture.circle()
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
            admin = true
        } else {
            admin = false
        }
    }
    
    
    @IBAction func ContinueAction(_ sender: UIBarButtonItem) {
        var name : String? = ""
        var surname : String? = ""
        
        for textField in textFields {
            switch textField.tag {
            case TagFields.name.rawValue :
                name = textField.text
                break
            case TagFields.surname.rawValue :
                surname = textField.text
                break
            default : break
            }
        }
        
        hasInsertedData = true
    
        NetworkManager.pushFinalUserData(name: name, surname: surname, image: image, hasInsertedData: hasInsertedData, hasAcceptedContract: hasAcceptedContract, admin: admin) { (success, err) in
            if success {
                self.performSegue(withIdentifier: R.segue.userInfoController.segueTerms.identifier, sender: self)
            }
            else {
                let alert = UIApplication.alertError(title: "Opss", message: err, closeAction: {})
                self.present(alert, animated: true, completion: nil)
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
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func checkImageSizeAndResize(image : UIImage) -> UIImage {
        let imageSize: Int = image.pngData()!.count
        let imageDimension = Double(imageSize) / 1024.0 / 1024.0
        print("size of image in MB: ", imageDimension)
        
        if imageDimension > 2 {
            let img = image.resized(withPercentage: 0.5) ?? UIImage()
            return checkImageSizeAndResize(image: img)
        }
        
        return image
    }
}


