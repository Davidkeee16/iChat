//
//  FirstMessageViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 23/07/2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human20.png"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Ben", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "You have the opportunity to chat with best man in the world", font: .systemFont(ofSize: 16, weight: .light))
    let myTextField = InsertableTextField()
    
    
    
    private let user: MUser
    
    init(user: MUser) {
        self.user = user
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.userInfo
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        customizeElements()
        setupConstraints()
    }
    private func customizeElements() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        
        aboutMeLabel.numberOfLines = 0
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        
        if let button = myTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
        
        
    }
    @objc private func sendMessage() {
        print(#function)
        
        guard let message = myTextField.text, message != "" else { return }
        
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChats(message: message, receiver: self.user) { result in
                switch result {
                case .success:
                    if let topVC = UIApplication.getTopViewController() {
                        AlertManager.showAlert(on: topVC, title: "Successful", message: "Message send to \(self.user.username)")
                    }
                case .failure(let error):
                    if let topVC = UIApplication.getTopViewController() {
                        AlertManager.showAlert(on: topVC, title: "Error", message: "Message not send, \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(myTextField)
        
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            myTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 16),
            myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            myTextField.heightAnchor.constraint(equalToConstant: 48)
            
        ])
    }
  }






import SwiftUI

struct FirstMessageVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<FirstMessageVCProvider.ContainerView>) -> ProfileViewController {
            return ProfileViewController(user: userExample)
        }
        func updateUIViewController(_ uiViewController: FirstMessageVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<FirstMessageVCProvider.ContainerView>) {
        }
    }
}
