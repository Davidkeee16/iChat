//
//  WelcomeBackViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 29/06/2025.
//

import Foundation
import UIKit


class WelcomeBackViewController: UIViewController {
    
    let welcomeBackLabel = UILabel(text: "Welcome Back!", font: .openSans26(), isBold: true)
    
    
    let googleImage = UIImageView(image: UIImage(named: "googleImage"))
    let googleButton = UIButton(title: "Google", titleColor: .darkButton(), backgroundColor: .mainWhite(), isShadow: true)
    
    let logInWith = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Passowrd")
    
    let emailTextField = TextFieldLine(font: .avenir20(), typeTF: .email)
    let passwordTextField = TextFieldLine(font: .avenir20(), typeTF: .password)
    
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .darkButton(), cornerRadius: 4)
    let needAnAccountLabel = UILabel(text: "Need an account?", font: .openSans16())
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.redButton(), for: .normal)
        button.titleLabel?.font = .openSans16()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        buttonTargets()
    }
    
}

extension WelcomeBackViewController {
    
    private func setupView() {
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 8)
        
        view.addSubview(welcomeBackLabel)
        view.addSubview(logInWith)
        view.addSubview(googleButton)
        view.addSubview(orLabel)
        view.addSubview(emailStackView)
        view.addSubview(passwordStackView)
        view.addSubview(loginButton)
        view.addSubview(googleImage)
        view.addSubview(bottomStackView)
        
       
        
        welcomeBackLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        logInWith.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints  = false
        googleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeBackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeBackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        NSLayoutConstraint.activate([
            logInWith.topAnchor.constraint(equalTo: welcomeBackLabel.bottomAnchor, constant: 60),
            logInWith.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            googleButton.topAnchor.constraint(equalTo: logInWith.bottomAnchor, constant: 21),
            googleButton.heightAnchor.constraint(equalToConstant: 60),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            
            googleImage.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor),
            googleImage.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 24),
            googleImage.heightAnchor.constraint(equalToConstant: 18),
            googleImage.widthAnchor.constraint(equalToConstant: 18)
            
        ])
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 39),
            orLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 40),
            emailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 41),
            passwordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 42),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
        ])
    }
    
    // MARK: Targets
    
    private func buttonTargets() {
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func signUpButtonTapped() {
        
        let vc = SignUpViewController()
        vc.isModalInPresentation  = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func loginButtonTapped() {
        
        guard let email = self.emailTextField.text, !email.isEmpty else { return AlertManager.showAlert(on: self, title: "Invalid Email", message: "Please enter your email") }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return AlertManager.showAlert(on: self, title: "Invalid Password", message: "Enter your password") }
        
        let userLogin = LoginUserRequest(email: email, password: password)
        
        AuthService.shared.signIn(with: userLogin) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error is Error {
                    AlertManager.showInavlidPasswordOrEmail(on: self)
                    return
                } else {
                    let vc = SetUpProfileViewController(currentUser: Auth.auth().currentUser!)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
}



import SwiftUI
import FirebaseAuth


struct WelcomeBackVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomeBackVCProvider.ContainerView>) -> WelcomeBackViewController {
            return WelcomeBackViewController()
        }
        func updateUIViewController(_ uiViewController: WelcomeBackVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WelcomeBackVCProvider.ContainerView>) {
        }
    }
}


