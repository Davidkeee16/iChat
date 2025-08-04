//
//  ChatRoom.swift
//  iChat
//
//  Created by David Puksanskis on 04/08/2025.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    lazy var textField: UITextField = {
        let textField = InsertableTextField()
        textField.returnKeyType = .send
        

        textField.delegate  = self
        
        
        
        
       return textField
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    
    private func configureUI() {
        
        view.addSubview(tableView)
        view.addSubview(textField)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: textField.topAnchor),
            
            
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            textField.heightAnchor.constraint(equalToConstant: 48)
            
            
            
        ])
    }
}

// MARK: TableView delegate and data source
extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        
        return cell
    }
}

// MARK: TextField Delegate

extension ChatRoomViewController: UITextFieldDelegate {
    
}





import SwiftUI


struct ChatRoomVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatRoomVCProvider.ContainerView>) -> ChatRoomViewController {
            return ChatRoomViewController()
        }
        func updateUIViewController(_ uiViewController: ChatRoomVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatRoomVCProvider.ContainerView>) {
        }
    }
}



