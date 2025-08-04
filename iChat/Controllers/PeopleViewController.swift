//
//  PeopleViewController.swift
//  iChatHomework
//
//  Created by David Puksanskis on 01/07/2025.
//

import Foundation
import UIKit


class PeopleViewController: UIViewController {
    
    let users = Bundle.main.decode([MUser].self, from: "nearbyPeople.json")
    
    var collectionView: UICollectionView!
    var dataSource:
    UICollectionViewDiffableDataSource<SectionUser, MUser>!
    
    enum SectionUser: Int, CaseIterable {
        case users
        
        func description(userCount: Int) -> String {
            switch self {
            case .users:
                return "\(userCount) people Nearby"
            }
        }
        
    }
    
    
    
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        setupCollectionView()
        searchBarSetup()
        configureDataSource()
        reloadData(with: nil)
        
      
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
    func configure<T: SelfConfiguringCell>(cellType: T.Type, with value: MUser, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unknow cell")
        }
        cell.configure(with: value)
        
        return cell
    }
    
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<SectionUser, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, nearbyPeople) -> UICollectionViewCell? in
            
            
            guard let section = SectionUser(rawValue: indexPath.section) else { fatalError("Unknown Section kind")
            }
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: NearbyPeopleCell.self, with: nearbyPeople, for: indexPath)
                
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
        
        
        collectionView.register(NearbyPeopleCell.self, forCellWithReuseIdentifier: NearbyPeopleCell.reuseId)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        
        
        
        
        
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







