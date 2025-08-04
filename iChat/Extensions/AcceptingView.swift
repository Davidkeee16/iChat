//
//  UIViewAccepting.swift
//  iChatHomework
//
//  Created by David Puksanskis on 23/07/2025.
//

import UIKit



class AcceptingView: UIView {
    
    
    
    private let username: UILabel
    private let inviteText: UILabel
    private let acceptButton: UIButton
    private let denyButton: UIButton
    
    
    
    init(username: UILabel, inviteText: UILabel, acceptButton: UIButton, denyButton: UIButton) {
        
        
        self.username = username
        self.inviteText = inviteText
        self.acceptButton = acceptButton
        self.denyButton = denyButton
        
        super.init(frame: .zero)
        
        
        constraintAcceptingView()
        self.backgroundColor = #colorLiteral(red: 0.9750193954, green: 0.97865659, blue: 0.9938426614, alpha: 1)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        
       
        
    }
    
    private func constraintAcceptingView() {
        
        let stackView = UIStackView(arrangedSubviews: [username, inviteText], axis: .vertical, spacing: 8)
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        self.addSubview(buttonsStackView)
    
        acceptButton.layer.cornerRadius = 10
        denyButton.layer.cornerRadius = 10
        
        
        
        
        NSLayoutConstraint.activate([
            acceptButton.widthAnchor.constraint(equalTo: denyButton.widthAnchor)
        ])
        
        
       
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            
            
        ])
        NSLayoutConstraint.activate([
            
            buttonsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 56)
            
            
        ])
       
        
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



