//
//  FirstMessageView.swift
//  iChatHomework
//
//  Created by David Puksanskis on 23/07/2025.
//

import UIKit


class FirstMessageView: UIView {
    private let username: UILabel
    private let friendHobby: UILabel
    private let sendMessageTF: UITextField
    
    init(username: UILabel, friendHobby: UILabel, sendMessageTF: UITextField) {
        self.username = username
        self.friendHobby = friendHobby
        self.sendMessageTF = sendMessageTF
        
        
        super.init(frame: .zero)
        
        backgroundColor = #colorLiteral(red: 0.9750193954, green: 0.97865659, blue: 0.9938426614, alpha: 1)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        
        
        setupConstraints()
        
    }
    
    
    
    
    
    private func setupConstraints() {
        
        /*
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        line.layer.cornerRadius = 18
        
        line.layer.shadowColor = UIColor.black.cgColor
        
        line.layer.shadowRadius = 18
        line.layer.shadowOpacity = 0.25
        line.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        
        NSLayoutConstraint.activate([
            
            line.topAnchor.constraint(equalTo: sendMessageTF.topAnchor, constant: -16),
            line.leadingAnchor.constraint(equalTo: sendMessageTF.leadingAnchor, constant: -16),
            line.trailingAnchor.constraint(equalTo: sendMessageTF.trailingAnchor, constant: 16),
            line.bottomAnchor.constraint(equalTo: sendMessageTF.bottomAnchor, constant: 16)
        ])
        
        
        */
        
        let stackView = UIStackView(arrangedSubviews: [username, friendHobby], axis: .vertical, spacing: 7)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageTF.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.addSubview(stackView)
        self.addSubview(sendMessageTF)
        
        
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -181)
        ])
        NSLayoutConstraint.activate([
            sendMessageTF.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            sendMessageTF.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            sendMessageTF.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sendMessageTF.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    
    
    
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
