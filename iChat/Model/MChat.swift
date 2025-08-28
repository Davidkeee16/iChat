//
//  MChat.swift
//  iChatHomework
//
//  Created by David Puksanskis on 21/07/2025.




import UIKit
import Combine
import FirebaseFirestore




struct MChat: Hashable {
    let friendUsername: String
    let friendAvatarStringURL: String
    let lastMessageContent: String
    let friendId: String
    
    var representation: [String: Any] {
        return ["friendUsername": friendUsername,
        "friendAvatarStringURL": friendAvatarStringURL,
        "friendId": friendId,
        "lastMessageContent": lastMessageContent
       ]
    }
    init(friendUsername: String, friendAvatarStringURL: String, friendId: String, lastMessageContent: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.friendId = friendId
        self.lastMessageContent = lastMessageContent
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
        let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
        let friendId = data["friendId"] as? String,
        let lastMessageContent = data["lastMessageContent"] as? String else { return nil }
        
        
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.friendId = friendId
        self.lastMessageContent = lastMessageContent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
