//
//  MainTabBarController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 01/07/2025.
//

import FirebaseAuth
import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: MUser
    init(currentUser: MUser = MUser(username: "frfer",
                                    email: "fr",
                                    avatarStringURL: "fer",
                                    userInfo: "fre",
                                    sex: "ewr",
                                    id: "fregtr")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        
        tabBar.tintColor = #colorLiteral(red: 0.6054775715, green: 0.3954312503, blue: 0.9792621732, alpha: 1)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        
        viewControllers = [
            
            generateNavigationController(rootViewController: listViewController, title: "Conversations", image: convImage),
            generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}




