//
//  HomeVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/10.
//

import UIKit
import AVFoundation
import SnapKit

class HomeVC: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.identifier)
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: RecommendCell.identifier)
        
        return collectionView
    }()

    let movieViewModel = MovieViewModel()
    let savedViewModel = SavedViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension HomeVC {  // About UI Setup
    func setup() {
        let tabBarHeight: CGFloat = (self.tabBarController?.tabBar.frame.size.height)!
   
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarHeight + 30)
        }
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self?.mainCompositionalLayout()
            default: return self?.recommendCompositionalLayout()
            }
        }
    }
    
    private func mainCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    private func recommendCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        return section
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {    // About CollectionView Showing
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return movieViewModel.awardMovies.count
        case 2:
            return movieViewModel.hotMovies.count
        case 3:
            return movieViewModel.myMovies.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath) as? MainCell else { return UICollectionViewCell() }
        guard let recommendCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCell.identifier, for: indexPath) as? RecommendCell else { return UICollectionViewCell() }

        switch indexPath.section {
        case 0:
            mainCell.updateUI(movieViewModel.mainMovie)
            mainCell.playButtonTapHandler = { [weak self] item, movie in
                self?.playMainMovie(item: item, movie: movie)
            }
            return mainCell
        case 1:
            recommendCell.updateUI(movieViewModel.awardMovies[indexPath.item])
            return recommendCell
        case 2:
            recommendCell.updateUI(movieViewModel.hotMovies[indexPath.item])
            return recommendCell
        case 3:
            recommendCell.updateUI(movieViewModel.myMovies[indexPath.item])
            return recommendCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.identifier, for: indexPath) as? CollectionViewHeaderView else { return UICollectionReusableView() }
        
        switch indexPath.section {
        case 1:
            header.updateUI(.award)
        case 2:
            header.updateUI(.hot)
        case 3:
            header.updateUI(.my)
        default:
            break
        }
        
        return header
    }
}

extension HomeVC {  // About Main Video Play
    func playMainMovie(item: AVPlayerItem, movie: Movie) {
        DispatchQueue.main.async {
            let vc = PlayerViewVC()

            vc.modalPresentationStyle = .fullScreen
            vc.player.replaceCurrentItem(with: item)
            vc.movieInfo = movie
            self.present(vc, animated: true, completion: nil)
        }
    }
}


