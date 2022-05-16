//
//  Home2VC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/10.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let movieViewModel = MovieViewModel()
    let savedViewModel = SavedViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension HomeVC {  // about Compositional Layout
    func setup() {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.mainCompositionalLayout()
            default: return self.recommendCompositionalLayout()
            }
        }
        collectionView.collectionViewLayout = layout
        
        let mainCellNib = UINib(nibName: String(describing: MainCell.self), bundle: nil)
        let recommendCellNib = UINib(nibName: String(describing: RecommendCell.self), bundle: nil)
        
        collectionView.register(mainCellNib.self, forCellWithReuseIdentifier: "mainCell")
        collectionView.register(recommendCellNib.self, forCellWithReuseIdentifier: "recommendCell")

        collectionView.contentInsetAdjustmentBehavior = .never
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

        return section
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
        guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? MainCell else { return UICollectionViewCell() }
        guard let recommendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendCell else { return UICollectionViewCell() }

        switch indexPath.section {
        case 0:
            mainCell.thumbnailImage.image = movieViewModel.mainMovie.thmbnail
            mainCell.playButtonTapHandler = { [weak self] item, movie in
                self?.playMainMovie(item: item, movie: movie)
            }
            return mainCell
        case 1:
            recommendCell.thumbnailImage.image = movieViewModel.awardMovies[indexPath.item].thmbnail
            return recommendCell
        case 2:
            recommendCell.thumbnailImage.image = movieViewModel.hotMovies[indexPath.item].thmbnail
            return recommendCell
        case 3:
            recommendCell.thumbnailImage.image = movieViewModel.myMovies[indexPath.item].thmbnail
            return recommendCell
        default:
            return UICollectionViewCell()
        }
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
    func playMainMovie(item: AVPlayerItem, movie: Movie) {
        let sb = UIStoryboard(name: "Player", bundle: nil)
        DispatchQueue.main.async {
            guard let vc = sb.instantiateViewController(withIdentifier: "PlayerViewVC") as? PlayerViewVC else { return }

            vc.modalPresentationStyle = .fullScreen
            vc.player.replaceCurrentItem(with: item)
            vc.movieInfo = movie
            self.present(vc, animated: true, completion: nil)
        }
    }
}


