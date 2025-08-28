//
//  SelfConfiguringCell.swift
//  iChatHomework
//
//  Created by David Puksanskis on 14/07/2025.
//

import UIKit


protocol SelfConfiguringCell {
    
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
