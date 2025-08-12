//
//  MUser.swift
//  iChatHomework
//
//  Created by David Puksanskis on 21/07/2025.
//


import UIKit
import Combine



struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var avatarStringURL: String
    var userInfo: String
    var sex: String
    var id: String
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["avatarStringUrl"] = avatarStringURL
        rep["userInfo"] = userInfo
        rep["sex"] = sex
        rep["uid"] = id
       return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        
        return username.lowercased().contains(lowercasedFilter)
    }
    
}
