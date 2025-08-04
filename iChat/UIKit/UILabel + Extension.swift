//
//  UILabel + Extension.swift
//  iChatHomework
//
//  Created by David Puksanskis on 16/06/2025.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir16(), isBold: Bool = false) {
        self.init()
        
        self.text = text
        self.font = font
        
        if isBold {
            
            self.font = .boldSystemFont(ofSize: font?.pointSize ?? 20)
        }
    }
}
    
    
