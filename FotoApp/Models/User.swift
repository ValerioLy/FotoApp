//
//  User.swift
//  Verifica
//
//  Created by Valerio Ly on 12/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//

import RealmSwift

@objcMembers class User: Object, Codable {
    dynamic var id : String!
    dynamic var email : String!
    dynamic var name : String?
    dynamic var surname : String?
    dynamic var image : String?
    dynamic var admin : Bool?
    dynamic var hasAcceptedTerms : Bool?
    dynamic var hasInsertedData : Bool?
    
    convenience init(id: String? = nil,email : String, name: String? = nil, surname: String? = nil, image: String? = nil, admin : Bool? = nil, hasAcceptedTerms: Bool? = nil, hasInsertedData: Bool? = nil) {
        self.init()
        
        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
        self.image = image
        self.admin = admin
        self.hasAcceptedTerms = hasAcceptedTerms
        self.hasInsertedData = hasInsertedData
    }
    
    /*func getId() -> String {
        return self.id
    }*/
    
  
    func getName() -> String {
        return self.name ?? ""
    }
    
    func getSurname() -> String {
        return self.surname ?? ""
    }
    
    func fullName() -> String {
        var fullname = ""
        fullname += self.name! + " " + self.surname!
        return fullname
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
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> User? {
        return realm.object(ofType: User.self, forPrimaryKey: id)
    }
    
    static func all(in realm: Realm = try! Realm(configuration: RealmUtils.config)) -> [User] {
        return  Array(realm.objects(User.self))
    }
    
    
}
