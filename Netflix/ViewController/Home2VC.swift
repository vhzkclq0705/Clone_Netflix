//
//  Home2VC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/10.
//

import UIKit

class Home2VC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.mainCompositionalLayout()
            case 1: return self.secondCompositionalLayout()
            case 2: return self.thirdCompositionalLayout()
            default: return self.fourthCompositionalLayout()
            }
        }
        collectionView.collectionViewLayout = layout
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

extension Home2VC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .blue
        case 2:
            cell.backgroundColor = .white
        case 3:
            cell.backgroundColor = .green
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension Home2VC {
    private func mainCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        
        return section
    }
    
    private func secondCompositionalLayout() -> NSCollectionLayoutSection {
        return self.subCompositionalLayout(index: 0)
    }
    
    private func thirdCompositionalLayout() -> NSCollectionLayoutSection {
        return self.subCompositionalLayout(index: 1)
    }
    
    private func fourthCompositionalLayout() -> NSCollectionLayoutSection {
        return self.subCompositionalLayout(index: 2)
    }
    
    private func subCompositionalLayout(index: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        //let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(20))
        
        //let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SectionHeaderView.identifier[index], alignment: .top)
        
        //header.pinToVisibleBounds = true
        //section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}
