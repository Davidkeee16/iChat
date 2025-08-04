//
//  ProfileCircle.swift
//  iChatHomework
//
//  Created by David Puksanskis on 01/07/2025.
//


import UIKit


class ProfileCircle: UIView {
    
    let profileImage: UIImageView
    /*
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ProfileImageAdd")
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 1
        return image
    }()
    */
    let addImageButton: UIButton
    /*
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addImageCircle"), for: .normal)
        button.tintColor = .addImageButtonColor()
        return button
    }()
    */
    init(frame: CGRect, profileImage: UIImageView, addImageButton: UIButton) {
        
        self.profileImage = profileImage
        self.addImageButton = addImageButton
        
        super.init(frame: frame)
        
        addSubview(profileImage)
        addSubview(addImageButton)
        setupConstraints()
    }
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.topAnchor),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            addImageButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            addImageButton.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 11),
            addImageButton.heightAnchor.constraint(equalToConstant: 22),
            addImageButton.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        self.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: addImageButton.trailingAnchor).isActive = true
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
}

