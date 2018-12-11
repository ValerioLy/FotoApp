//
//  NetworkManager.swift
//  FotoApp
//
//  Created by Nicola on 03/12/18.
//

import UIKit
import Firebase
import FirebaseStorage
import CodableFirebase

class NetworkManager: NSObject {
    private static let USERS_COLLECTION = "users"
    private static let ALBUMS_COLLECTION = "albums"
    private static let PHOTOS_COLLECTION = "photos"
    private static var db : Firestore = Firestore.firestore()
    private static var storageRef : StorageReference = Storage.storage().reference()

    static func initFirebase() {
        FirebaseApp.configure()
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
    
    static func uploadPhoto(image : UIImage, albumId : String, completion : @escaping(Bool, String?) -> ()) {
//        guard let user = Auth.auth().currentUser else {
//            completion(false, "No such user")
//            return
//        }
        
        let userId = "cHDvdcf4aaVHFhbj9biI8gIeKim2"
        let photoId = UUID().uuidString
        
        let folderRef = storageRef.child("\(albumId)/\(photoId).jpg")
        folderRef.putData(image.pngData() ?? Data(), metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                completion(false, error!.localizedDescription)
                return
            }
            folderRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(false, error!.localizedDescription)
                    return
                }
                
                db.collection(PHOTOS_COLLECTION).document(photoId).setData([
                    "id" : photoId,
                    "author" : userId,
                    "date" : Date().dateInString,
                    "link" : downloadURL.absoluteString,
                    "accepted" : true
                ]) { error in
                    guard error == nil else {
                        completion(false, error!.localizedDescription)
                        return
                    }
                    
                    db.collection(ALBUMS_COLLECTION).document(albumId).setData([
                        "photos" : FieldValue.arrayUnion([photoId])
                    ], merge : true) { error in
                        guard error == nil else {
                            completion(false, error!.localizedDescription)
                            return
                        }
                        
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    static func getAlbumListener(albumId : String) -> ListenerRegistration? {
//        guard let user = Auth.auth().currentUser else {
//            completion(false, "No such user")
//            return
//        }
        
        return db.collection(ALBUMS_COLLECTION).document(albumId).addSnapshotListener(includeMetadataChanges: false) { documentSnapshot, error in
            
            guard let data = documentSnapshot?.data() else {
                return
            }
            
            do {
                try FirebaseDecoder().decode(Album.self, from: data).save()
            }
            catch let err {
                debugPrint(err.localizedDescription)
                return
            }
            
            // send push notification to HomepageController
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "photoListener"), object: nil)
        }
    }
    
    static func fetchAlbums(ids : [String], completion : @escaping (Bool, String?) -> ()) {
//        guard let user = Auth.auth().currentUser else {
//            completion(false, "No such user")
//            return
//        }
        
        var fetchCount = 0

        ids.forEach({ (item) in
            
            db.collection(PHOTOS_COLLECTION).whereField("id", isEqualTo : item)
                .getDocuments() { (querySnapshot, err) in
                    guard err == nil else {
                        completion(false, err!.localizedDescription)
                        return
                    }
                    
                    if let elementFound = querySnapshot?.documents.first?.data() {
                        do {
                            try FirebaseDecoder().decode(Photo.self, from: elementFound).save()
                            fetchCount = fetchCount + 1
                        }
                        catch let err {
                            completion(false, err.localizedDescription)
                        }
                        
                        if fetchCount == ids.count {
                            completion(true, nil)
                        }
                    }
                    else {
                        debugPrint("not found with id: \(item)")
                    }
            }
            
        })
    }

}
