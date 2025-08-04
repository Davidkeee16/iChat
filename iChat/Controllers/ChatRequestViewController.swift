//
//  AcceptingViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 23/07/2025.
//

import UIKit


class ChatRequestViewController: UIViewController {
    
    
    
    let friendImage = UIImageView(image: UIImage(named:"human20"), contentMode: .scaleAspectFill)
    
    let username = UILabel(text: "Ronnie McDaniel", font: .avenir20(), isBold: true)
    let inviteText = UILabel(text: "You have the opportunity to start a new chat", font: UIFont(name: "Avenir", size: 14))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .mainWhite(), backgroundColor: .red)
    let denyButton = UIButton(title: "Deny", titleColor: .redButton(), backgroundColor: .mainWhite(), isBorder: true)

        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        setupBottomSheet()
        setupFriendImage()
        
        
        
    }
    
    
    
    private func setupBottomSheet() {
        
        
        
        
        let bottomSheet = AcceptingView(username: username, inviteText: inviteText, acceptButton: acceptButton, denyButton: denyButton)
        
       
        
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomSheet)
        
        inviteText.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            bottomSheet.heightAnchor.constraint(equalToConstant: 206),
            bottomSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
        
        acceptButton.applyGradients(cornerRadius: 10)
        acceptButton.clipsToBounds = true
    }
    private func setupFriendImage() {
        
        view.insertSubview(friendImage, at: 0)
        
        friendImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            friendImage.topAnchor.constraint(equalTo: view.topAnchor),
            friendImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }

}









import SwiftUI

struct AcceptingVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AcceptingVCProvider.ContainerView>) -> ChatRequestViewController {
            return ChatRequestViewController()
        }
        func updateUIViewController(_ uiViewController: AcceptingVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AcceptingVCProvider.ContainerView>) {
        }
    }
}




