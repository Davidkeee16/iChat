//
//  ListViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 01/07/2025.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting Chats"
            case .activeChats:
                return "Active Chats"
            }
        }
    }
    private var currentUser: MUser
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
    
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats) { result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    if self.waitingChats != [], self.waitingChats.count <= chats.count {
                        let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                        chatRequestVC.delegate = self
                        self.present(chatRequestVC, animated: true)
                    }
                    self.waitingChats = chats
                    self.reloadData()
                }
            case .failure(let error):
                AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
            }
        }
        
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats) { result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    if self.activeChats != chats {
                        self.activeChats = chats
                        self.reloadData()
                    }
                }
            case .failure(let error):
                AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    private func reloadData() {
        DispatchQueue.main.async {
            
            let waitingIDs = Set(self.waitingChats.map { $0.friendId })
            let activeIDs  = Set(self.activeChats.map { $0.friendId })
            let movedIDs   = waitingIDs.intersection(activeIDs)

            
            var snap1 = NSDiffableDataSourceSnapshot<Section, MChat>()
            snap1.appendSections([.waitingChats, .activeChats])

            let waitingPhase1 = self.waitingChats.filter { !movedIDs.contains($0.friendId) }
            let activePhase1  = self.activeChats.filter  { !movedIDs.contains($0.friendId) }

            snap1.appendItems(waitingPhase1, toSection: .waitingChats)
            snap1.appendItems(activePhase1,  toSection: .activeChats)

            self.dataSource?.apply(snap1, animatingDifferences: false)

            
            var snap2 = NSDiffableDataSourceSnapshot<Section, MChat>()
            snap2.appendSections([.waitingChats, .activeChats])

            let waitingFinal = self.waitingChats.filter { !activeIDs.contains($0.friendId) }
            snap2.appendItems(waitingFinal,       toSection: .waitingChats)
            snap2.appendItems(self.activeChats,   toSection: .activeChats)

            self.dataSource?.apply(snap2, animatingDifferences: true)
        }
    }

   
    private func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
                
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            }
        })
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can not create new section header") }
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind") }
            sectionHeader.configure(text: section.description(),
                                    font: .laoSangamMN20(),
                                    textColor: #colorLiteral(red: 0.6216047406, green: 0.6185544133, blue: 0.6358836293, alpha: 1))
           return sectionHeader
        }
    }
    private func setupCollectionView() {
    
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .mainWhite()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        
        collectionView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    

extension ListViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .waitingChats:
                return self.createWaitingChats()
            case .activeChats:
                return self.createActiveChats()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    private func createWaitingChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
        
        
    private func createActiveChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(84))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        
        return sectionHeader
    }
    
}
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true)
        case .activeChats:
            let chatRoom = ChatRoomViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatRoom, animated: true)
        }
    }
}
extension ListViewController: WaitingChatsNavigation {
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result {
            case .success:
                AlertManager.showAlert(on: self, title: "Successful", message: "Message with \(chat.friendUsername) was deleted")
            case .failure(let error):
                AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    func changeToActive(chat: MChat) {
        FirestoreService.shared.changeToActive(chat: chat) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                AlertManager.showAlert(on: self, title: "Successful", message: "You can now get in touch with \(chat.friendUsername)")
            case .failure(let error):
                AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
            }
        }
    }
}


import SwiftUI

struct ListVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) -> MainTabBarController {
            return MainTabBarController(currentUser: userExample)
        }
        func updateUIViewController(_ uiViewController: ListVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) {
        }
    }
}
