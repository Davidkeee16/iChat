//
//  MMessage.swift
//  iChat
//
//  Created by David Puksanskis on 20/08/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import MessageKit

struct MMessage: Hashable, MessageType {
    
    let content: String
    var sender: SenderType
    let sentDate: Date
    let id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKit.MessageKind {
        return .text(content)
    }
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        if let ts = data["created"] as? Timestamp {
            self.sentDate = ts.dateValue()
        } else if let date = data["created"] as? Date {
            self.sentDate = date
        } else {
            return nil
        }
        
        guard let senderId = data["senderId"] as? String else { return nil }
        guard let senderUsername = data["senderUsername"] as? String else { return nil }
        guard let content = data["content"] as? String else { return nil }
        
        self.id = document.documentID
        sender = Sender(senderId: senderId, displayName: senderUsername)
        self.content = content
    }
    
    var representation: [String: Any] {
        return  [
            "created": sentDate,
            "senderId": sender.senderId,
            "senderUsername": sender.displayName,
            "content": content
        ]
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}
extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
