//
//  UIButton + Extension.swift
//  iChatHomework
//
//  Created by David Puksanskis on 16/06/2025.
//

import Foundation
import UIKit


extension UIButton {
    
    convenience init(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont? = .avenir20(), isShadow: Bool = false, cornerRadius: CGFloat = 4, isBorder: Bool = false){
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        if isBorder {
            self.layer.borderWidth = 1
            self.layer.borderColor = #colorLiteral(red: 0.8756850362, green: 0.2895075381, blue: 0.2576965988, alpha: 1)
        }
    }
}
    
   
