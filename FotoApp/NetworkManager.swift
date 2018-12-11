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
    private static var storageRef : StorageReference = Storage.storage().reference()

    static func initFirebase() {
        FirebaseApp.configure()
        
      
    }
    
    
    
    
    
    
    static func checkUserInfo(completion : @escaping(Bool)->() )
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
        }}
    
    
    
    
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
    


static func updateTerms(hasAcceptedContract: Bool, completion: @escaping(Bool) -> ()){
    
    guard let user = Auth.auth().currentUser else {
        completion(false)
        return
        
    }
    
        self.db.collection(USERS_COLLECTION).document(user.uid).updateData([
            "hasAcceptedContract": hasAcceptedContract
        ])
    
}

}


