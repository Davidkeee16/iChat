//
//  SetUpProfile.swift
//  iChatHomework
//
//  Created by David Puksanskis on 30/06/2025.
//


import UIKit
import FirebaseAuth
import FirebaseStorage
import SDWebImage


class SetUpProfileViewController: UIViewController {
    
    let setUpProfileLabel = UILabel(text: "Set up profile", font: .avenir26())
    
    let profilePhoto = ProfileCircle()
    let fullNameLabel = UILabel(text: "Full Name")
    let aboutMeLabel = UILabel(text: "About Me")
    
    let fullNameTF = TextFieldLine(font: .avenir20(), typeTF: .username)
    let aboutMeTF = TextFieldLine(font: .avenir20(), typeTF: .username)
    
    let goChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .darkButton(), cornerRadius: 4)
    let segmentedControlSex = UISegmentedControl(items: ["Male", "Female"])
    let genderLabel = UILabel(text: "Sex")
    
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let username = currentUser.displayName {
            fullNameTF.text = username
        }
        if let photoURL = currentUser.photoURL {
            profilePhoto.profileImage.sd_setImage(with: photoURL)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var logoutButton: UIButton = {
        $0.setTitle("Logout", for: .normal)
        $0.titleLabel?.font = .openSans16()
        $0.setTitleColor(.redButton(), for: .normal)
        return $0
    } (UIButton())
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        buttonTargets()
        
        
        FirestoreService.shared.getUserData(user: currentUser) { result in
            switch result {
            case .success(let muser):
                
                
                if let url = URL(string: muser.avatarStringURL) {
                    DispatchQueue.main.async {
                        self.profilePhoto.profileImage.sd_setImage(with: url)
                    }
                }
                self.fullNameTF.text = muser.username
                self.aboutMeTF.text = muser.userInfo
                let recivedString = muser.sex
                if let index = (0..<self.segmentedControlSex.numberOfSegments).first(where: {
                    self.segmentedControlSex.titleForSegment(at: $0) == recivedString
                }) {
                    self.segmentedControlSex.selectedSegmentIndex = index
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
         
    }
}

extension SetUpProfileViewController {
    
    private func setupView() {
        
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTF], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTF], axis: .vertical, spacing: 0)
        let segmentedStackView = UIStackView(arrangedSubviews: [genderLabel, segmentedControlSex], axis: .vertical, spacing: 11)
        
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
        
        self.profilePhoto.addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.goChatsButton.addTarget(self, action: #selector(tappedGoToChats), for: .touchUpInside)
        self.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc func addImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    @objc func tappedGoToChats() {
        
        FirestoreService.shared.saveProfileWith(id: currentUser.uid, email: currentUser.email!, username: fullNameTF.text, avatarImage: profilePhoto.profileImage.image, userInfo: aboutMeTF.text, sex: segmentedControlSex.titleForSegment(at: segmentedControlSex.selectedSegmentIndex)) { result in
            switch result {
            case .success(let muser):
                AlertManager.successfulAlert(on: self) {
                    let tabBar = MainTabBarController(currentUser: muser)
                    let navVC = UINavigationController(rootViewController: tabBar)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                    
                    let photoRef = StorageService.shared.storageRef.child("avatars")
                    photoRef.downloadURL { url, _ in
                        if let downloadURL = url {
                            StorageService.shared.getPhoto(from: downloadURL, into: self.profilePhoto.profileImage)
                        }
                    }
                    
                    
                    self.fullNameTF.text = muser.username
                    self.aboutMeTF.text = muser.userInfo
                    let recivedString = muser.sex
                    if let index = (0..<self.segmentedControlSex.numberOfSegments).first(where: {
                        self.segmentedControlSex.titleForSegment(at: $0) == recivedString
                    }) {
                        self.segmentedControlSex.selectedSegmentIndex = index
                    }
                    
                }
            case .failure(let error):
                AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
            }
        }
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

extension SetUpProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        profilePhoto.profileImage.image = image
    }
}

/*

import SwiftUI



struct SetUpVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetUpVCProvider.ContainerView>) -> SetUpProfileViewController {
            return SetUpProfileViewController(currentUser: Auth.auth().currentUser!)
        }
        func updateUIViewController(_ uiViewController: SetUpVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetUpVCProvider.ContainerView>) {
        }
    }
}

*/
