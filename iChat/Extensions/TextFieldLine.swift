//
//  TextFieldLine.swift
//  iChatHomework
//
//  Created by David Puksanskis on 29/06/2025.
//

import Foundation
import UIKit


class TextFieldLine: UITextField {
    
    enum textFieldType {
        case email
        case password
        case username
    }
    
    
    convenience init(font: UIFont? = .avenir20(), typeTF: textFieldType) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        
        
        var bottomLine = UIView()
        bottomLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        bottomLine.backgroundColor = .textFieldLineColor()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        
        switch typeTF {
        case .email:
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.isSecureTextEntry = true
            self.textContentType = .oneTimeCode
        case .username:
            self.keyboardType = .alphabet
        }
        
        
        self.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
