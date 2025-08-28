//
//  PeopleViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 01/07/2025.
//

import FirebaseAuth
import FirebaseFirestore
import SDWebImage
import UIKit


class PeopleViewController: UIViewController {
    
    
    var users = [MUser]()
    private var usersListener: ListenerRegistration?
    
    var collectionView: UICollectionView!
    var dataSource:
    UICollectionViewDiffableDataSource<SectionUser, MUser>!
    
    enum SectionUser: Int, CaseIterable {
        case users
        func description(userCount: Int) -> String {
            switch self {
            case .users:
                return "\(userCount) people nearby"
            }
        }
    }
    
    lazy var gearshapeTapped: UIAction = UIAction { [weak self] _ in
        
        let vc = SetUpProfileViewController(currentUser: Auth.auth().currentUser!)
        self?.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), primaryAction: gearshapeTapped)
        
        searchBarSetup()
        setupCollectionView()
        configureDataSource()
        
        usersListener = ListenerService.shared.usersObserve(users: users) { result in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                AlertManager.showAlert(on: self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    deinit {
        usersListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadData(with searchText: String?, animatingDifferences: Bool = true) {
        
        let filtered = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionUser, MUser>()
        
        snapshot.appendSections([.users])
        snapshot.appendItems(filtered, toSection: .users)
        
        
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
        
    
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<SectionUser, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, nearbyPeople) -> UICollectionViewCell? in
            
            
            guard let section = SectionUser(rawValue: indexPath.section) else { fatalError("Unknown Section kind")
            }
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: nearbyPeople, for: indexPath)
                
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new section header") }
            guard let section = SectionUser(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            let items = self.dataSource?.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(userCount: items!.count), font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
            
            return sectionHeader
        }
    }
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        collectionView.delegate = self
    }
    
    
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = SectionUser(rawValue: sectionIndex) else { fatalError("Unknown section kind")
            }
            
            switch section {
            case .users:
                return self.createUsersSections()
            }
        }
        
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    
    private func createUsersSections() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let spacing: CGFloat = 15
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 15, bottom: 0, trailing: 15)
        
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
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true)

    }
}



extension PeopleViewController: UISearchBarDelegate {
    
    private func searchBarSetup() {
        
        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let searchController = UISearchController(searchResultsController: nil)
        
        
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    
}




import SwiftUI
import FirebaseAuth

struct PeopleVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) -> MainTabBarController {
            return MainTabBarController()
        }
        func updateUIViewController(_ uiViewController: PeopleVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) {
        }
    }
}







