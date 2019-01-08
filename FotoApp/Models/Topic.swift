//
//  Mission.swift
//  FotoApp
//
//  Created by Marco Cozza on 04/12/2018.
//

import RealmSwift
import Foundation
import Firebase
import FirebaseFirestore

@objcMembers class Topic: Object, Codable {
    
    dynamic var id : String!
    dynamic var title : String!
    dynamic var descriptio : String!
    dynamic var creation : String!
    dynamic var expiration : String!
    dynamic var creator : String!
    
    var workers : List<String> = List()
    var albums : List<String> = List()
    

    
    convenience init(id : String? = nil, title : String? = nil, descriptio : String? = nil, creation : String? = nil, expiration : String? = nil, creator : String? = nil ){
        
        self.init()
        
        self.title = title
        self.id = id
        self.descriptio = descriptio
        self.creation = creation
        self.expiration = expiration
        self.creator = creator
    }
    
    func getTitle() -> String {
        return self.title ?? ""
    }
    
    
  
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func all(in realm: Realm = try! Realm(configuration: RealmUtils.config)) -> [Topic] {
        return Array(realm.objects(Topic.self))
    }
    
    func save(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {}
    }
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> Topic? {
        return realm.object(ofType: Topic.self, forPrimaryKey: id)
    }
    
    func deleteAllTopic(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
                for topic in Topic.all() {
                    topic.delete()
                }
    }
    
    func delete(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.delete(self)
            }
        } catch {}
    }

    func getAlbum() -> [String]{
        return Array(albums)
    }
}
