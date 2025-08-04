//
//  ViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 16/06/2025.
//

import UIKit

class AuthViewController: UIViewController {
    
    let logo = UIImageView(image: UIImage(named: "LogoAPP"), contentMode: .scaleAspectFill)
    
    let googleText = UILabel(text: "Get started with")
    let emailText = UILabel(text: "Or sign up with")
    let logInText = UILabel(text: "Already onboard?")
    
    let googleImage = UIImageView(image: UIImage(named: "googleImage"))
    
    let emailButton = UIButton(title: "Email", titleColor: .mainWhite(), backgroundColor: .darkButton())
    let googleButton = UIButton(title: "Google", titleColor: .darkButton(), backgroundColor: .mainWhite(), isShadow: true)
    let logInButton = UIButton(title: "Log in", titleColor: .redButton(), backgroundColor: .mainWhite(), isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        buttonTargets()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupView() {
        
        let googleView = ButtonFormView(label: googleText, button: googleButton)
        let emailView = ButtonFormView(label: emailText, button: emailButton)
        let logInView = ButtonFormView(label: logInText, button: logInButton)
        
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, logInView], axis: .vertical, spacing: 40)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        googleImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logo)
        view.addSubview(stackView)
        view.addSubview(googleImage)
        
        
        
        NSLayoutConstraint.activate([
            
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -142),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
        googleImage.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor),
        googleImage.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 24),
        googleImage.heightAnchor.constraint(equalToConstant: 18),
        googleImage.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
    // MARK: Targets
    
    private func buttonTargets() {
        self.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        self.googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        self.logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func emailButtonTapped() {
        
        let vc = WelcomeBackViewController()
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    
    @objc func googleButtonTapped() {
        
    }
    @objc func logInButtonTapped() {
        
    }
}














import SwiftUI

struct AuthVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) -> AuthViewController {
            return AuthViewController()
        }
        func updateUIViewController(_ uiViewController: AuthVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthVCProvider.ContainerView>) {
        }
    }
}

