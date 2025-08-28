//
//  UserCell.swift
//  iChat
//
//  Created by David Puksanskis on 18/08/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    let userImageView = UIImageView()
    let username = UILabel(text: "Alexey")
    let containerView = UIView()
    
    static var reuseId = "UserCell"
    
    func configure<U>(with value: U) where U : Hashable {
        
        guard let user = value as? MUser else { return }
        username.text = user.username
        guard let url = URL(string: user.avatarStringURL) else { return }
        DispatchQueue.main.async {
            self.userImageView.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = #colorLiteral(red: 0.7422972322, green: 0.7422972322, blue: 0.7422972322, alpha: 1)
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
        
        setupConstraints()
    
    }
    override func prepareForReuse() {
        userImageView.image = nil
    }
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

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
