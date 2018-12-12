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
     private static let TOPICS_COLLECTION = "topics"
    private static let ALBUMS_COLLECTION = "albums"
    private static let PHOTOS_COLLECTION = "photos"
    private static var db : Firestore = Firestore.firestore()
    private static var storageRef : StorageReference = Storage.storage().reference()

    static func initFirebase() {
        FirebaseApp.configure()
        
      
    }
    
    static func checkUserInfo(hasInsertedData: Bool, completion : @escaping(Bool)->() )
    {
        guard let user = Auth.auth().currentUser else {
            completion(false)
           print("Non prende l'utente")
            return
        }

        db.collection(self.USERS_COLLECTION).document(user.uid).getDocument { (DocumentSnapshot, Error) in
            if let err = Error {
                print("Error getting documents: \(err)")
            } else {
                let dati = DocumentSnapshot?.data()
                
                let hasInsertedData = dati!["hasInsertedData"] as? Bool
                    guard hasInsertedData == true else {
                        completion(false)
                        print("Non ha inserito i dati")
                        return
                    }
                
                
        }
        completion(true)
    }    
    }
    
    
    
    static func checkTermsUser(completion : @escaping(Bool)->() )
    {  guard let user = Auth.auth().currentUser else {
        completion(false)
        print("Non prende l'utente")
        return
        }
        db.collection(self.USERS_COLLECTION).document(user.uid).getDocument { (DocumentSnapshot, Error) in
            if let err = Error {
                print("Error getting documents: \(err)")
            } else {
                let dati = DocumentSnapshot?.data()
                
                let hasAcceptedContract = dati!["hasAcceptedContract"] as? Bool
                guard hasAcceptedContract == true else {
                    completion(false)
                    print("Non ha inserito i dati")
                    return
                }
            }
            completion(true)
        }
    }
    
    
    
    
    
    static func uploadTopics(title : String, descriptio : String, expiration : String, creator : String, workers : [String], albums : [String], completion: @escaping (Bool) -> ()) {
        
        guard let user = Auth.auth().currentUser else { completion(false); return}
        
        db.collection(self.TOPICS_COLLECTION).addDocument(data: ["id": UUID().uuidString, "title" : title, "descriptio" : descriptio, "expiration": expiration, "creation": Date().dateInString, "creator": user.uid, "workers": workers, "albums": albums], completion: { (error) in
            
            if let err = error{
                print("Job could not be saved: \(error).")
            }
            else {
                print("Job saved successfully!")
                completion(true)
            }
        })
    }
        
        
      
    
    
    static func getData (completion: @escaping([Users])-> Void) {

        db.collection(self.USERS_COLLECTION).getDocuments() { (querySnapshot, err) in
            
            var userList = [Users]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    //let user = Users()
                    let userData = document.data()
                    
                    let idU = userData["id"] as? String ?? ""
                    let nameU = userData["name"] as? String ?? ""
                    let surnameU = userData["surname"] as? String ?? ""
                    let email = userData["email"] as? String ?? ""
                    let image = userData["image"] as? String ?? ""
                    var admin : Bool, data : Bool, contract : Bool
                    if userData["admin"] as? String == "true"{
                        admin = true
                    }else{
                        admin = false
                    }
                    if userData["hasInsertedData"] as? String == "true"{
                        data = true
                    }else{
                        data = false
                    }
                    if userData["hasAcceptedContract"] as? String == "true"{
                        contract = true
                    }else{
                        contract = false
                    }
                    
                    
                    /*user.name = userData["name"] as? String ?? ""
                    user.surname = userData["surname"] as? String ?? ""*/
                    
                    let user = Users(id: idU, email: email, name: nameU, surname: surnameU, image: image, admin: admin, hasAcceptedTerms: contract, hasInsertedData: data)
                    
                    //userList += [user]
                    userList.append(user)
                }
                
            }
            completion(userList)
        }
        
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
    
    static func getTopics(){
        db.collection("topics").whereField("workers", arrayContains:
            
            Auth.auth().currentUser?.uid).addSnapshotListener { (querySnapshot, error) in
            
            guard let docs = querySnapshot?.documents else {
                return
            }
            
            docs.forEach({ (item) in
                let data = item.data()
                
                debugPrint(data)
                
                do {
                    try FirebaseDecoder().decode(Topic.self, from: data).save()
                }
                catch let err {
                    debugPrint(err.localizedDescription)
                    return
            }
            })
            

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topicListener"), object: nil)
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
    
    static func pushUserData(email: String, hasInsertedData: Bool, hasAcceptedContract : Bool, completion: @escaping(Bool, String?) -> ()){
        
        guard let user = Auth.auth().currentUser else {
            completion(false, "No such user")
            return
        }
            self.db.collection(USERS_COLLECTION).document(user.uid).setData([
                "id":user.uid,
                "email": email,
                "hasInsertedData": hasInsertedData,
                "hasAcceptedContract": hasAcceptedContract
            ], merge: true) { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    

    static func pushFinalUserData(name: String? = nil, surname: String? = nil, image : UIImage? = nil, hasInsertedData: Bool, hasAcceptedContract : Bool, admin: Bool, completion: @escaping(Bool, String?) -> ()){
        
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
                        "name": name ,
                        "surname": surname ,
                        "image": downloadURL.absoluteString,
                        "hasInsertedData": hasInsertedData,
                        "hasAcceptedContract": hasAcceptedContract,
                        "admin":admin
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
                "name": name ,
                "surname": surname ,
                "image": "",
                "hasInsertedData": hasInsertedData,
                "hasAcceptedContract": hasAcceptedContract,
                  "admin":admin
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
        guard let user = Auth.auth().currentUser else {
            completion(false, "No such user")
            return
        }
        
        let userId = user.uid
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
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
    }
    
    static func fetchAlbums(ids : [String], completion : @escaping (Bool, String?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            completion(false, "No such user")
            return
        }
        
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


