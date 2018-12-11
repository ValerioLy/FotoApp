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
     private static let WORKER_COLLECTION = "workers"
    private static var db : Firestore = Firestore.firestore()
    private static var storageRef : StorageReference!

    static func initFirebase() {
        FirebaseApp.configure()
        
        storageRef = Storage().reference()
    }
    
    
    
    
    
    
    static func checkUserInfo(hasInsertedData: Bool, completion : @escaping(Bool)->() )
    {
        guard let user = Auth.auth().currentUser else {
            completion(false)
           print("Non prende l'utente")
            return
        }
        guard hasInsertedData == true else {
                completion(false)
            print("Non ha inserito i dati")
            return
        }
        completion(true)
    }
    
    
    
    
    
    static func uploadWorkerInfo( title : String, description : String, data : String, idUser : [String],     completion: @escaping (Bool) -> ()) {
        
        guard let user = Auth.auth().currentUser else { completion(false); return}
        
        db.collection(self.WORKER_COLLECTION).document(user.uid).setData([ "id":user.uid, "title" : title, "description" : description, "data": data, "idUser": idUser], merge: true, completion: { (error) in
            
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
