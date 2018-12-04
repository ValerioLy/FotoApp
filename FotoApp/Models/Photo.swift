//
//  Photo.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit
import RealmSwift
import FirebaseFirestore

@objcMembers class Photo: Object {
    dynamic var id : String!
    dynamic var author : String!
    dynamic var date : Date!
    dynamic var link : String!
    dynamic var accepted : Bool! = true
    
    convenience init(id : String, author : String, date : Date, link : String, accepted : Bool? = true) {
        self.init()
        
        self.id = id
        self.author = author
        self.date = date
        self.link = link
        self.accepted = accepted
    }    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func save(in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {}
    }
    
    static func getObject(in realm: Realm = try! Realm(), withId id : String) -> Photo? {
        return realm.object(ofType: Photo.self, forPrimaryKey: id)
    }
    
}
