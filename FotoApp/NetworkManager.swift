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
    private static let TOPICS_COLLECTION = "topics"
    
    private static var db : Firestore = Firestore.firestore()
    private static var storageRef : StorageReference = Storage.storage().reference()
    
    static func initFirebase() {
        FirebaseApp.configure()
    }
    
    static func getUserId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    
    static func getImageData(completion: @escaping(Bool, String) -> ())  {
        
        self.db.collection("photos").getDocuments { (snapshot, err) in
            
            if let err = err {
                print("Non prende i documenti: \(err)")
                completion(false, "")
            } else {
                let firstDocument = snapshot!.documents.first

                let docId = firstDocument!.documentID.first
                let link = firstDocument!.get("link") as! String

                completion(true, link)
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    static func checkedLoggedUser(completion : @escaping (Bool) -> ()) {
        if Auth.auth().currentUser != nil {
            completion(true)
        }
        else {
            completion(false)
        }
    }
    
    static func checkUserInfo(completion : @escaping(Bool)->() ) {
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
    
    static func updateTerms(hasAcceptedContract : Bool, completion : @escaping(Bool) -> ()) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        self.db.collection(USERS_COLLECTION).document(user.uid).updateData([
            "hasAcceptedContract": hasAcceptedContract
        ]) { error in
            completion(error == nil)
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
    
    static func uploadTopics(title : String, descriptio : String, expiration : String, workers : [String], completion: @escaping (Bool) -> ()) {
        guard let user = Auth.auth().currentUser else { completion(false); return}
        
        let id = UUID().uuidString
        
        db.collection(TOPICS_COLLECTION).document(id).setData([
            "id": id,
            "title" : title,
            "descriptio" : descriptio,
            "expiration": expiration,
            "creation": Date().dateInString,
            "creator": user.uid,
            "workers": workers,
            "albums": []
        ]) { error in
            completion(error == nil)
        }
    }
    
    static func getUserData(completion: @escaping(Bool, String?) -> ())  {
        guard let user = Auth.auth().currentUser else {
            completion(false, "No such user")
            return
        }
        
        db.collection(USERS_COLLECTION).document(user.uid).getDocument { (documentSnap, err) in
            guard err == nil else {
                completion(false, err?.localizedDescription)
                return
            }
            
            if let data = documentSnap?.data() {
                do {
                    try FirebaseDecoder().decode(User.self, from: data).save()
                    completion(true, nil)
                }
                catch let err {
                    completion(false, err.localizedDescription)
                    return
                }
            }
            else {
                completion(false, "No such data")
                return
            }
        }
    }
    
    static func getAllUsers(completion: @escaping([User]?, String?) -> ()) {
        guard Auth.auth().currentUser != nil else {
            completion(nil, "No such user")
            return
        }
        
        db.collection(USERS_COLLECTION).whereField("admin", isEqualTo: false).getDocuments { (querySnap, err) in
            guard err == nil else {
                completion(nil, err?.localizedDescription)
                return
            }
            
            if let docs = querySnap?.documents {
                var list : [User] = []
                docs.forEach({ (doc) in
                    do {
                        list.append(try FirebaseDecoder().decode(User.self, from: doc.data()))
                    }
                    catch {
                        completion(nil, error.localizedDescription)
                        return
                    }
                })
                
                completion(list, nil)
            }
        }
    }
    
    static func register(email:String, password: String, completion: @escaping (Bool, String?)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                completion(true, nil)
            } else {
                UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: "Error", message: "Register not Correct", closeAction: {
                    completion(false, error?.localizedDescription)
                }), animated: true, completion: nil)
            }
        }
    }
    
    static func login(email:String, password: String, completion: @escaping (Bool, String?)->()) {
        
        Auth.auth().signIn(withEmail: email, password : password) { (user, error) in
            guard let _ = user else {
                UIApplication.topViewController()?.present(GeneralUtils.share.alertError(title: "Error", message: "The User Not Exists", closeAction: {
                    completion(false, error?.localizedDescription)
                }), animated: true, completion: nil)
                return
            }
            completion(true, nil)
        }
    }
    
    static func getTopics(){
        var currentUser : User = User.getObject(withId: Auth.auth().currentUser!.uid)!
        
        if currentUser.admin {
            db.collection("topics").whereField("creator", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener { (querySnapshot, error) in
                
                guard let docs = querySnapshot?.documents else {
                    return
                }
                let tpo : Topic = Topic()
                tpo.deleteAllTopic()
                docs.forEach({ (item) in
                    let data = item.data()
                    
                    do {
                        try FirebaseDecoder().decode(Topic.self, from: data).save()
                    }
                    catch let err {
                        return
                    }
                })
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topicListener"), object: nil)
            }
        }
            
        else{
            db.collection("topics").whereField("workers", arrayContains:Auth.auth().currentUser?.uid).addSnapshotListener { (querySnapshot, error) in
                
                guard let docs = querySnapshot?.documents else {
                    return
                }
                let tpo : Topic = Topic()
                tpo.deleteAllTopic()
                docs.forEach({ (item) in
                    let data = item.data()
                    
                    do {
                        try FirebaseDecoder().decode(Topic.self, from: data).save()
                    }
                    catch let err {
                        return
                    }
                })
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topicListener"), object: nil)
            }
        }
    }
    
    static func getTopicsJobDetail(id: String,completion: @escaping(Bool, Topic?) -> ()){
        db.collection("topics").whereField("id", isEqualTo:id).addSnapshotListener { (querySnapshot, error) in
            var topic : Topic?
            guard let docs = querySnapshot?.documents else {
                completion(false,nil)
                return
            }
            
            docs.forEach({(item) in
                let data = item.data()
                do {
                    topic = try FirebaseDecoder().decode(Topic.self, from: data)
                }
                catch let error{
                    completion(false,nil)
                    return
                }
            })
            if topic == nil{
                completion(false,nil)
            }
            
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topicListener"), object: nil)
            completion(true,topic)
        }
    }
    
    static func getTopicListeners(idTopic : String) -> [ListenerRegistration?]? {
        guard Auth.auth().currentUser != nil else {
            return nil
        }
        
        let topicListener = db.collection(TOPICS_COLLECTION).document(idTopic)
            .addSnapshotListener { documentSnapshot, error in
                
                guard let data = documentSnapshot?.data() else {
                    return
                }
                
                do {
                    try FirebaseDecoder().decode(Topic.self, from: data).save()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "albumsListener"), object: nil)
                }
                catch {
                    return
                }
        }
        
        let albumsListener = db.collection(ALBUMS_COLLECTION).whereField("topicId", isEqualTo: idTopic).addSnapshotListener { (querySnap, err) in
            
            if let snap = querySnap {
                snap.documentChanges.forEach({ (item) in
                    var album : Album?
                    
                    do {
                        album = try FirebaseDecoder().decode(Album.self, from: item.document.data())
                    }
                    catch let err {
                        debugPrint(err)
                        return
                    }
                    
                    if item.type == .removed {
                        album?.delete()
                    }
                    else {
                        album?.save()
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "albumsListener"), object: nil)
                })
            }
            else {
                debugPrint(err?.localizedDescription ?? "No error")
            }
        }
        
        return [topicListener, albumsListener]
    }
    
    static func logout(completion: @escaping (Bool) -> ()) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            completion(true)
        }   catch let error as NSError {
            
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
                    "authorName" : User.getObject(withId: userId)?.fullName(),
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
    
    static func uploadAlbum(topicId : String, title : String, descr : String, completion : @escaping(Bool, String?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            completion(false, "No such user")
            return
        }
        
        let userName = "Admin"
        let albumId = UUID().uuidString
        db.collection(ALBUMS_COLLECTION).document(albumId).setData([
            "id" : albumId,
            "title" : title,
            "descr" : descr,
            "createdBy" : user.uid,
            "topicId" : topicId,
            "createdByName" : userName,
            "isPendingForDeletion" : false,
            "dateAdd" : Date().dateInString,
            "photos" : []
        ]) { error in
            guard error == nil else {
                completion(false, error!.localizedDescription)
                return
            }
            
            completion(true, nil)
        }
    }
    
    static func changePendingDeletionForAlbum(pending : Bool, albumId : String, completion: @escaping(Bool, String?) ->()) {
        guard Auth.auth().currentUser != nil else {
            completion(false, "No such user")
            return
        }
        
        self.db.collection(ALBUMS_COLLECTION).document(albumId).updateData([
            "isPendingForDeletion" : pending
        ]) { error in
            guard error == nil else {
                completion(false, error!.localizedDescription)
                return
            }
            
            completion(true, nil)
        }
    }
    
    static func getAlbumListener(albumId : String) -> ListenerRegistration? {
        guard Auth.auth().currentUser != nil else {
            return nil
        }
        
        return db.collection(ALBUMS_COLLECTION).document(albumId).addSnapshotListener(includeMetadataChanges: false) { documentSnapshot, error in
            
            guard let data = documentSnapshot?.data() else {
                return
            }
            
            do {
                try FirebaseDecoder().decode(Album.self, from: data).save()
            }
            catch let err {
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "photoListener"), object: nil)
        }
    }
    
    static func fetchPhotos(ids : [String], completion : @escaping (Bool, String?) -> ()) {
        guard Auth.auth().currentUser != nil else {
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
            }
            
        })
    }
}


