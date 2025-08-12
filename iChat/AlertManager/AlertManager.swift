//
//  AlertManager.swift
//  iChat
//
//  Created by David Puksanskis on 30/07/2025.
//

import UIKit


class AlertManager {
    
    
    private static func showBasicAlert(on viewController: UIViewController,title: String, message: String?) {
    
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
    
    
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        self.showBasicAlert(on: viewController, title: title, message: message)
    }
    static func successfulAlert(on viewController: UIViewController, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Succesful", message: "Your information updated", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            })
        }
    }
    
    
}


extension AlertManager {
    static func showAlertWhenPasswordsNotMatching(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Invalid confirm password", message: "Passwords do not match.")
    }
    static func showInavlidPasswordOrEmail(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Invalid Email or Password", message: "Please enter valid Email or Password")
    }
    static func showRegistredSuccesfull(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Sucessfull", message: "You are registered!")
    }
    static func registrationError(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Wrong email", message: "User with this email registered!")
    }
    
    
    
}



