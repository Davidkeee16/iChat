//
//  MChat.swift
//  iChatHomework
//
//  Created by David Puksanskis on 21/07/2025.




import UIKit
import Combine




struct MChat: Hashable, Decodable {
    
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.id == rhs.id
    }
}
