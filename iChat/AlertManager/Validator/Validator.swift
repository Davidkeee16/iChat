//
//  Validator.swift
//  iChat
//
//  Created by David Puksanskis on 31/07/2025.
//

import UIKit

class Validator {
    
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailPredicate.evaluate(with: email)
    }
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let email = email,
              let password = password,
              password != "", email != "" else { return false }
        return true
    }
    static func isFilledProfile(fullName: String?, userInfo: String?, sex: String?) -> Bool {
        guard let fullName = fullName,
              let userInfo = userInfo,
              let sex = sex,
              fullName != "", userInfo != "", sex != "" else { return false }
        return true
    }
}
