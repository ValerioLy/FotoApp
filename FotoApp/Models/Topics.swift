//
//  User.swift
//  Verifica
//
//  Created by Valerio Ly on 12/11/18.
//  Copyright © 2018 Valerio Ly. All rights reserved.
//
import UIKit
import RealmSwift

@objcMembers class Topics: Object{
    dynamic var id : String!
    dynamic var titolo : String!
    dynamic var descrizione : String?
    dynamic var dataAgg : Data?
    dynamic var scadenza : Data?
    dynamic var createdby : String?
    
   private let workers : List<User> = List<User>()
//   private let album : List<Album> = List<Album>()
    
    convenience init(titolo: String? = nil, descrizione: String? = nil, dataAgg: Data? = nil, scadenza : Data? = nil, createdby : String? = nil) {
        self.init()
        
        self.id = UUID().uuidString
        self.titolo = titolo
        self.descrizione = descrizione
        self.dataAgg = dataAgg
        self.scadenza = scadenza
        self.createdby = createdby
       
    }
//    
//    func getId() -> String {
//        return self.id
//    }
    
    
   
    
}
