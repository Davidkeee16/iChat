//
//  SetUpProfile.swift
//  iChatHomework
//
//  Created by David Puksanskis on 30/06/2025.
//


import UIKit
import FirebaseAuth


class SetUpProfileViewController: UIViewController {
    
    let setUpProfileLabel = UILabel(text: "Set up profile", font: .avenir26())
    
    
    let fullNameLabel = UILabel(text: "Full Name")
    let aboutMeLabel = UILabel(text: "About Me")
    
    let fullNameTF = TextFieldLine(font: .avenir20(), typeTF: .username)
    let aboutMeTF = TextFieldLine(font: .avenir20(), typeTF: .username)
    
    let goChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .darkButton(), cornerRadius: 4)
    let segmentedControl = UISegmentedControl(items: ["Male", "Female"])
    let genderLabel = UILabel(text: "Sex")
    
    
    
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ProfileImageAdd")
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 1
        return image
    }()
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addImageCircle"), for: .normal)
        button.tintColor = .addImageButtonColor()
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = .openSans16()
        button.setTitleColor(.redButton(), for: .normal)
        
        return button
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        buttonTargets()
    }
    
}

extension SetUpProfileViewController {
    
    private func setupView() {
        
        let frame = CGRect()
        let profilePhoto = ProfileCircle(frame: frame,profileImage: profileImage, addImageButton: addImageButton)
        
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTF], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTF], axis: .vertical, spacing: 0)
        let segmentedStackView = UIStackView(arrangedSubviews: [genderLabel, segmentedControl], axis: .vertical, spacing: 11)
        
        view.addSubview(setUpProfileLabel)
        view.addSubview(profilePhoto)
        view.addSubview(fullNameStackView)
        view.addSubview(aboutMeStackView)
        view.addSubview(segmentedStackView)
        view.addSubview(goChatsButton)
        view.addSubview(logoutButton)
        
        setUpProfileLabel.translatesAutoresizingMaskIntoConstraints = false
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        fullNameStackView.translatesAutoresizingMaskIntoConstraints = false
        aboutMeStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        goChatsButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            setUpProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setUpProfileLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 138)
        ])
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: setUpProfileLabel.bottomAnchor, constant: 41),
            profilePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 138)
            
        
        ])
        NSLayoutConstraint.activate([
            fullNameStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 356),
            fullNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            fullNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            aboutMeStackView.topAnchor.constraint(equalTo: fullNameStackView.bottomAnchor, constant: 41),
            aboutMeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            aboutMeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
        NSLayoutConstraint.activate([
            segmentedStackView.topAnchor.constraint(equalTo: aboutMeStackView.bottomAnchor, constant: 40),
            segmentedStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            segmentedStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            goChatsButton.topAnchor.constraint(equalTo: segmentedStackView.bottomAnchor, constant: 41),
            goChatsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            goChatsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            goChatsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: goChatsButton.bottomAnchor, constant: 16),
            logoutButton.centerXAnchor.constraint(equalTo: goChatsButton.centerXAnchor)
        ])
    }
    
}
// MARK: Button Targets

extension SetUpProfileViewController {
    
    private func buttonTargets() {
        self.addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        self.goChatsButton.addTarget(self, action: #selector(tappedGoToChats), for: .touchUpInside)
        
        self.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc func addImage() {
        
    }
    @objc func tappedGoToChats() {
        
        let tabBar = MainTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
        
    }
    
    
    @objc func logoutTapped() {
        
        AuthService.shared.signOut { error in
            if error != nil {
                print("Error")
                return
            } else {
                
                let vc = WelcomeBackViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.isModalInPresentation = true
                self.present(vc, animated: true)
            }
            
        }
    }
    
    
    
}



import SwiftUI
import FirebaseAuth


struct SetUpVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetUpVCProvider.ContainerView>) -> SetUpProfileViewController {
            return SetUpProfileViewController()
        }
        func updateUIViewController(_ uiViewController: SetUpVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetUpVCProvider.ContainerView>) {
        }
    }
}


