//
//  Message.swift
//
//  Created by Francesco Baldan.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import Foundation
import MessageKit
import RealmSwift


@objcMembers class Message: Object, Codable {
    
    dynamic var id: String!
    dynamic var senderName: String!
    dynamic var senderId: String!
    dynamic var sentDate: String!
    dynamic var messageText: String!
    dynamic var topicId: String!
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(topicId: String, id: String, messageText: String, senderName: String, senderId: String, sentDate: Date) {
        self.init()
        self.id = id
        self.senderName = senderName
        self.senderId = senderId
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        self.sentDate = dateFormatter.string(from: sentDate)
        
        self.messageText = messageText
        self.topicId = topicId
        
    }
    
    func save(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {}
    }
    
    static func all(in realm: Realm = try! Realm(configuration: RealmUtils.config), withTopic id: String) -> [Message] {
        return Array(realm.objects(Message.self).filter({$0.topicId == id}).sorted(by: { $0.sentDate.compare($1.sentDate) == .orderedAscending }))
    }
    
    func remove(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.delete(realm.objects(Message.self).filter({$0.id == self.id}))
            }
        } catch {}
    }
    
    static func removeAll(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.delete(realm.objects(Message.self))
            }
        } catch {}
    }
    
}
