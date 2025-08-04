//
//  TextFieldFirstMessage.swift
//  iChatHomework
//
//  Created by David Puksanskis on 23/07/2025.
//



import UIKit

class FirstMessageTF: UITextField {
    
    private let placeholderText: String
    private let image: UIImageView
    private let button: UIButton
    
    
    
    init(placeholderText: String, image: UIImageView, button: UIButton) {
        
        self.placeholderText = placeholderText
        self.image = image
        self.button = button
        
        super.init(frame: .zero)
        
        
        self.placeholder = placeholderText
        
        self.backgroundColor = .mainWhite()
    
        self.leftView = image
        self.leftViewMode = .always
        
        
        
        
        self.rightView = button
        self.rightViewMode = .always
        
        
       
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
