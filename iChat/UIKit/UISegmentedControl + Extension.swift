//
//  UISegmentedControl + Extension.swift
//  iChatHomework
//
//  Created by David Puksanskis on 30/06/2025.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    convenience init(items: [String]) {
        self.init()
        
        for (index, item) in items.enumerated() {
            self.insertSegment(withTitle: item, at: index, animated: false)
        }
        
    }
}
