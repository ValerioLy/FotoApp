//
//  NetworkManager.swift
//  FotoApp
//
//  Created by Nicola on 03/12/18.
//

import UIKit
import Firebase
import FirebaseStorage

class NetworkManager: NSObject {
    private static let USERS_COLLECTION = "users"
    private static var db : Firestore!
    private static var storageRef : StorageReference!

    static func initFirebase() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        storageRef = Storage().reference()
    }
    
    static func register(email:String, password: String, completion: @escaping (Bool, String?)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    static func login(email:String, password: String, completion: @escaping (Bool, String?)->()) {
        
        Auth.auth().signIn(withEmail: email, password : password) { (user, error) in
            guard let _ = user else {
                completion(false, error!.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    static func logout(completion: @escaping (Bool) -> ()) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            completion(true)
        }   catch let error as NSError {
            print("Error signing out : %ç@", error)
            
            UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: "Error", message: error.localizedDescription, closeAction: {
                completion(false)
            }), animated: true, completion: nil)
        }
    }
    
    static func pushUserData(name: String? = nil, surname: String? = nil, email: String? = nil, image : UIImage? = nil, completion: @escaping(Bool, String?) -> ()){
        
        guard let user = Auth.auth().currentUser else {
            completion(false, "No such user")
            return
            
        }
        
        if let userImage = image {
            
            let folderRef = storageRef.child("\(user.uid)/profile-pic.jpg")
            _ = folderRef.putData(userImage.pngData() ?? Data(), metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    completion(false, error!.localizedDescription)
                    return
                }
                folderRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        completion(false, error!.localizedDescription)
                        return
                    }
                    
                    self.db.collection(USERS_COLLECTION).document(user.uid).setData([
                        "id":user.uid,
                        "name": name ,
                        "surname": surname ,
                        "email": email ,
                        "image": downloadURL.absoluteString
                    ], merge: true) { error in
                        if let error = error {
                            completion(false, error.localizedDescription)
                        } else {
                            completion(true, nil)
                        }
                    }
                }
            }
        }
        else {
            self.db.collection(USERS_COLLECTION).document(user.uid).setData([
                "id":user.uid,
                "name": name ,
                "surname": surname ,
                "email": email ,
                "image": nil
            ], merge: true) { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
