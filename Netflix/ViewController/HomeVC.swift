//
//  Home2VC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/10.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.mainCompositionalLayout()
            default: return self.recommendCompositionalLayout()
            }
        }
        collectionView.collectionViewLayout = layout
        
        let recommendCellNib = UINib(nibName: String(describing: RecommendCell.self), bundle: nil)
        collectionView.register(recommendCellNib, forCellWithReuseIdentifier: "recommendCell")
        //collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: "recommendCell")

        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.awardMovies.count
        case 2:
            return viewModel.hotMovies.count
        case 3:
            return viewModel.myMovies.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendCell else { return UICollectionViewCell() }

        switch indexPath.section {
        case 0:
            cell.thumbnailImage.image = UIImage(named: "img_header")!
            cell.thumbnailImage.contentMode = .scaleAspectFill
        case 1:
            cell.thumbnailImage.image = viewModel.awardMovies[indexPath.item].thmbnail
        case 2:
            cell.thumbnailImage.image = viewModel.hotMovies[indexPath.item].thmbnail
        case 3:
            cell.thumbnailImage.image = viewModel.myMovies[indexPath.item].thmbnail
        default:
            return UICollectionViewCell()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
        
        switch indexPath.section {
        case 1:
            header.headerLabel.text = Section.award.title
        case 2:
            header.headerLabel.text = Section.hot.title
        case 3:
            header.headerLabel.text = Section.my.title
        default:
            break
        }
        
        return header
    }
}

extension HomeVC {
    private func mainCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)

        return section
    }

    private func recommendCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: itemSize.heightDimension)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
}
