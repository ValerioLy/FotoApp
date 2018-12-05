//
//  User.swift
//  Verifica
//
//  Created by Valerio Ly on 12/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import RealmSwift

@objcMembers class Users: Object, Codable {
    dynamic var id : String!
    dynamic var email : String!
    dynamic var name : String?
    dynamic var surname : String?
    dynamic var image : String?
    dynamic var admin : Bool?
    dynamic var hasAcceptedTerms : Bool?
    dynamic var hasInsertedData : Bool?
    
    convenience init(email : String, name: String? = nil, surname: String? = nil, image: String? = nil, admin : Bool? = nil, hasAcceptedTerms: Bool? = nil, hasInsertedData: Bool? = nil) {
        self.init()
        
        self.id = email
        self.email = email
        self.name = name
        self.surname = surname
        self.image = image
        self.admin = admin
        self.hasAcceptedTerms = hasAcceptedTerms
        self.hasInsertedData = hasInsertedData
    }
    
    func getName() -> String {
        return self.name ?? ""
    }
    
    func getSurname() -> String {
        return self.surname ?? ""
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
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> Users? {
        return realm.object(ofType: Users.self, forPrimaryKey: id)
    }
    
    static func all(in realm: Realm = try! Realm(configuration: RealmUtils.config)) -> [Users] {
        return  Array(realm.objects(Users.self))
    }
    
    
}
