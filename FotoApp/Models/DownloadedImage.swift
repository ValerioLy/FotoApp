//
//  DownloadedImage.swift
//  FotoApp
//
//  Created by Nicola on 18/12/18.
//
//

import Foundation
import UIKit
import RealmSwift

@objcMembers class DownloadedImage: Object {
    dynamic var id : String!
    dynamic var data : Data!
    
    convenience init(id : String, data : Data) {
        self.init()
        
        self.id = id
        self.data = data
    }
    
    func save(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {}
    }
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> DownloadedImage? {
        return realm.object(ofType: DownloadedImage.self, forPrimaryKey: id)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
