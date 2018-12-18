//
//  Photo.swift
//  FotoApp
//
//  Created by Nicola on 04/12/18.
//

import UIKit
import RealmSwift
import FirebaseFirestore

@objcMembers class Photo: Object, Codable {
    dynamic var id : String!
    dynamic var author : String!
    dynamic var authorName : String!
    dynamic var date : String!
    dynamic var link : String!
    dynamic var accepted : Bool = true
    
    convenience init(id : String, author : String, date : String, link : String, accepted : Bool? = true) {
        self.init()
        
        self.id = id
        self.author = author
        self.date = date
        self.link = link
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
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> Photo? {
        return realm.object(ofType: Photo.self, forPrimaryKey: id)
    }
    
    static func getObjects(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId ids : [String]) -> [Photo] {
        var list : [Photo] = []
        
        ids.forEach { (item) in
            if let obj = realm.object(ofType : Photo.self, forPrimaryKey: item) {
                list.append(obj)
            }
        }
        
        return list
    }
}
