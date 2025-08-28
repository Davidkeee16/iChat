//
//  SignUpViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 29/06/2025.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Sveiki! Hello!", font: .avenir26())
    
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: .darkButton(), cornerRadius: 4)
    let emailLine = TextFieldLine(font: .avenir20(), typeTF: .email)
    let passwordLine = TextFieldLine(font: .avenir20(), typeTF: .password)
    let confirmPasswordLine = TextFieldLine(font: .avenir20(), typeTF: .password)
    
    let alreadyOnboardLabel = UILabel(text: "Already onboard?", font: .openSans16())
    
    lazy var loginButton: UIButton = {
        $0.setTitle("Login", for: .normal)
        $0.titleLabel?.font = .openSans16()
        $0.setTitleColor(.redButton(), for: .normal)
        return $0
    } (UIButton(primaryAction: loginButtonTapped))
    
    lazy var loginButtonTapped: UIAction = UIAction { [weak self] _ in
        let vc = WelcomeBackViewController()
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .fullScreen
        self?.present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupView()
        buttonTargets()
    }
    
    private func setupView() {
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailLine], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordLine], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordLine], axis: .vertical, spacing: 0)
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton], axis: .vertical, spacing: 40)
        
        let onboardStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 8)
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        onboardStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(onboardStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 62),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            onboardStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            onboardStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }

    // MARK: - Selectors
    
    private func buttonTargets() {
        
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        
       // self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func signUpButtonTapped() {
        
        guard let email = self.emailLine.text, !email.isEmpty, Validator.isValidEmail(for: email) else { return AlertManager.showAlert(on: self, title: "Wrong email", message: "Wrong format or field is empty") }
        guard let password = self.passwordLine.text, !password.isEmpty else { return }
        guard let confirmPassword = self.confirmPasswordLine.text, !confirmPassword.isEmpty else { return }
        
        
        if password != confirmPassword {
            AlertManager.showAlertWhenPasswordsNotMatching(on: self)
            return
        } else {
            
            let userRequest = RegisterUserRequest(email: email, password: password)
            
            AuthService.shared.registerUser(with: userRequest) { result in
                switch result {
                case .success(_):
                    AlertManager.showRegistredSuccesfull(on: self)
                    self.emailLine.text = ""
                    self.passwordLine.text = ""
                    self.confirmPasswordLine.text = ""
                    
                case .failure(let error):
                    AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    /* @objc func loginButtonTapped() {
        
        let vc = WelcomeBackViewController()
        vc.isModalInPresentation = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    */

}


import SwiftUI

struct SignUpVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainerView>) -> SignUpViewController {
            return SignUpViewController()
        }
        func updateUIViewController(_ uiViewController: SignUpVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SignUpVCProvider.ContainerView>) {
        }
    }
}
