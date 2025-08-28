//
//  UserError.swift
//  iChat
//
//  Created by David Puksanskis on 11/08/2025.
//

import UIKit


enum UserError {
    case notFilled
    case photoNotExist
    case cannotUnwrapToMUser
    case cannotGetUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fields cannot be emty", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User doesn't have an photo", comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString("Cannot unrwrap MUser from User", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Cannot get user info", comment: "")
        }
    }
}
