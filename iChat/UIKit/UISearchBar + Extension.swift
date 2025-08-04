//
//  UISearchBar + Extension.swift
//  iChatHomework
//
//  Created by David Puksanskis on 02/07/2025.
//

import Foundation
import UIKit


extension UISearchBar {
    
    convenience init(placeholder: String, cornerRadius: CGFloat = 4, isShadow: Bool = true) {
        self.init(frame: .zero)
        
        self.placeholder = placeholder
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.25
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
}
