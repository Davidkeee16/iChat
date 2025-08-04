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
}
