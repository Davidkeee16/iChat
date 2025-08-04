//
//  UIImage + Extension.swift
//  iChatHomework
//
//  Created by David Puksanskis on 17/06/2025.
//

import Foundation
import UIKit


extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: ContentMode) {
        
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
}
    
extension UIImageView {
    
    func setupColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
    
