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

@objcMembers class Mission: Object {
    
    dynamic var id : String!
    dynamic var name : String!
    dynamic var descriptio : String!
    dynamic var date : String!
    dynamic var expiring : String!
    dynamic var creator : String!
    //dynamic var workers
    
    convenience init(id : String? = nil, name : String? = nil, descriptio : String? = nil, date : String? = nil, expiring : String? = nil, creator : String? = nil ){
        
        self.init()
        
        self.name = name
        self.id = id
        self.descriptio = descriptio
        self.date = date
        self.expiring = expiring
        self.creator = creator
    }
    
    
    
    
    
    
}
