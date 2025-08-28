//
//  ActiveChatsCell.swift
//  iChatHomework
//
//  Created by David Puksanskis on 13/07/2025.
//

import UIKit
import SDWebImage



class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "ActiveChatCell"

    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name")
    let lastMessage = UILabel(text: "How are you?")
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8181462884, green: 0.6767815948, blue: 0.9631229043, alpha: 1), endColor: #colorLiteral(red: 0.5076757073, green: 0.7348275781, blue: 0.9381031394, alpha: 1))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainWhite()
        setupConstraints()
    
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        friendImageView.sd_cancelCurrentImageLoad()
        friendImageView.image = UIImage(named: "ProfileImageAdd")
    
    }
    
    func configure<U>(with value: U) where U: Hashable {
        guard let chat: MChat = value as? MChat else { return }
        guard let url = URL(string: chat.friendAvatarStringURL) else { friendImageView.image = UIImage(named: "ProfileImageAdd")
        return }
        
        friendImageView.sd_setImage(with: url,
        placeholderImage: UIImage(named: "ProfileImageAdd"),
        options: [.retryFailed, .continueInBackground, .scaleDownLargeImages, .refreshCached]) { [weak self] _, error, _, _ in
            if let error = error {
                print("Avatar load failed (\(chat.friendUsername)): \(error.localizedDescription)")
            }
        }
        friendName.text = chat.friendUsername
        lastMessage.text = chat.lastMessageContent
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActiveChatCell {
    
    private func setupConstraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .orange
        gradientView.backgroundColor = .black
        
        addSubview(friendImageView)
        addSubview(friendName)
        addSubview(gradientView)
        addSubview(lastMessage)
        
        
        NSLayoutConstraint.activate([
            
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),
            
        ])
        
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}
