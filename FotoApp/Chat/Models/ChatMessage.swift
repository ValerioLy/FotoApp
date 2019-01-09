//
//  ChatMessage.swift
//  FotoApp
//
//  Created by Marco Cozza on 08/01/2019.
//

import UIKit
import MessageKit

class ChatMessage: MessageType {
    
    var sender: Sender
    
    var messageId: String = ""
    
    var sentDate: Date
    
    var kind: MessageKind
    
    init(msg : Message) {
        self.messageId = msg.id
        self.sentDate = msg.sentDate.date ?? Date()
        self.kind = MessageKind.text(msg.messageText)
        self.sender = Sender(id: msg.senderId, displayName: msg.senderName)
    }
}
