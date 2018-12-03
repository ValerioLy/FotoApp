//
//  NetworkManager.swift
//  FotoApp
//
//  Created by Nicola on 03/12/18.
//

import UIKit
import Firebase

class NetworkManager: NSObject {
    private static var ref : DocumentReference!
    private static var db : Firestore!

    static func initFirebase() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    static func login(email:String, password: String, completion: @escaping (Bool)->()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
