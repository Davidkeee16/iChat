//
//  NearbyPeopleCell.swift
//  iChatHomework
//
//  Created by David Puksanskis on 21/07/2025.
//

import UIKit



class NearbyPeopleCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "nearbyPeople"
    
    let username = UILabel(text: "Alexey", font: .laoSangamMN20())
    let userImageView = UIImageView()
    let containerView = UIView()
    
    
    func configure<U>(with value: U) {
        
        guard let people = value as? MUser else { return }
        
        username.text = people.username
        userImageView.image = UIImage(named: people.avatarStringURL)
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainWhite()
        setupConstraints()
        
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
        self.layer.shadowRadius = 3
        self.layer.shadowColor = #colorLiteral(red: 0.7743276358, green: 0.7743276358, blue: 0.7743276358, alpha: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
       
        
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
}

extension NearbyPeopleCell {
    
    
    
    private func setupConstraints() {
        
        
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
        
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(username)
        
        
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            username.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            username.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            username.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        
        
        
    }
    
    
    
}
