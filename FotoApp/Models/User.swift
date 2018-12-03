//
//  User.swift
//  Verifica
//
//  Created by Valerio Ly on 12/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//
import UIKit
import RealmSwift

@objcMembers class User: Object {
    dynamic var id : String!
    dynamic var email : String!
    dynamic var password : String?
    dynamic var nome : String?
    dynamic var cognome : String?
    dynamic var image : String?

    
    convenience init(email : String, password : String! = nil, nome: String? = nil, cognome: String? = nil, image: String? = nil) {
        self.init()
        
        self.id = email
        self.email = email
        self.password = password
        self.nome = nome
        self.cognome = cognome
        self.image = image
      
    }
    override class func primaryKey() -> String? {
        return "id"
    }

    func save(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {}
    }
    
}
