//
//  Album.swift
//  FotoApp
//
//  Created by Nicola on 10/12/18.
//
//

import Foundation
import RealmSwift
import Firebase

@objcMembers class Album: Object, Codable {
    dynamic var id : String!
    dynamic var title : String!
    dynamic var descr : String!
    dynamic var topicId : String!
    dynamic var createdBy : String!
    dynamic var dateAdd : String!
    dynamic var isPendingForDeletion : Bool = false
    dynamic var createdByName : String!
    var photos : List<String> = List()
    
    convenience init(id : String, title : String, descr : String, createdBy : String, dateAdd : String) {
        self.init()
        
        self.id = id
        self.title = title
        self.descr = descr
        self.createdBy = createdBy
        self.dateAdd = dateAdd
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
    
    func delete(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.delete(realm.objects(Album.self).filter({$0.id == self.id}))
            }
        } catch {}
    }
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), forTopic topicId : String) -> [Album] {
        return Array(realm.objects(Album.self).filter("topicId = '\(topicId)'"))
    }
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> Album? {
        return realm.object(ofType: Album.self, forPrimaryKey: id)
    }
}
