////
////  Home2VC.swift
////  Netflix
////
////  Created by 권오준 on 2022/05/10.
////
//
//import UIKit
//import AVFoundation
//import SnapKit
//
//class HomeVC: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    private lazy var collectionView2: UICollectionView = {
//        let layout = createLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(MainCell.self, forCellWithReuseIdentifier: "mainCell")
//        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: "recommendCell")
//
//        return collectionView
//    }()
//
//    let movieViewModel = MovieViewModel()
//    let savedViewModel = SavedViewModel.shared
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//    }
//}
//
//extension HomeVC {  // about Compositional Layout
//    func setup() {
//        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
//            switch section {
//            case 0: return self.mainCompositionalLayout()
//            default: return self.recommendCompositionalLayout()
//            }
//        }
//        collectionView.collectionViewLayout = layout
//
//        let mainCellNib = UINib(nibName: String(describing: MainCell.self), bundle: nil)
//        let recommendCellNib = UINib(nibName: String(describing: RecommendCell.self), bundle: nil)
//
//        collectionView.register(mainCellNib.self, forCellWithReuseIdentifier: "mainCell")
//        collectionView.register(recommendCellNib.self, forCellWithReuseIdentifier: "recommendCell")
//
//        collectionView.contentInsetAdjustmentBehavior = .never
//    }
//
//    func setup2() {
//        view.addSubview(collectionView2)
//        collectionView2.delegate = self
//        collectionView2.dataSource = self
//
//        collectionView2.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//
//    func createLayout() -> UICollectionViewCompositionalLayout {
//        return UICollectionViewCompositionalLayout { [weak self] (section, _) -> NSCollectionLayoutSection? in
//            switch section {
//            case 0: return self?.mainCompositionalLayout()
//            default: return self?.recommendCompositionalLayout()
//            }
//        }
//    }
//
//    private func mainCompositionalLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(500))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = itemSize
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        return section
//    }
//
//    private func recommendCompositionalLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: itemSize.heightDimension)
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
//
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [header]
//        section.orthogonalScrollingBehavior = .continuous
//
//        return section
//    }
//}
//
//extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return Section.allCases.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return movieViewModel.awardMovies.count
//        case 2:
//            return movieViewModel.hotMovies.count
//        case 3:
//            return movieViewModel.myMovies.count
//        default:
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell2.identifier, for: indexPath) as? MainCell2 else { return UICollectionViewCell() }
//        guard let recommendCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCell2.identifier, for: indexPath) as? RecommendCell2 else { return UICollectionViewCell() }
//
//        switch indexPath.section {
//        case 0:
//            mainCell.updateUI(movieViewModel.mainMovie)
//            mainCell.playButtonTapHandler = { [weak self] item, movie in
//                self?.playMainMovie(item: item, movie: movie)
//            }
//            return mainCell
//        case 1:
//            recommendCell.updateUI(movieViewModel.awardMovies[indexPath.item])
//            return recommendCell
//        case 2:
//            recommendCell.updateUI(movieViewModel.hotMovies[indexPath.item])
//            return recommendCell
//        case 3:
//            recommendCell.updateUI(movieViewModel.myMovies[indexPath.item])
//            return recommendCell
//        default:
//            return UICollectionViewCell()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else { return UICollectionReusableView() }
//
//        switch indexPath.section {
//        case 1:
//            header.updateUI(.award)
//        case 2:
//            header.updateUI(.award)
//        case 3:
//            header.updateUI(.award)
//        default:
//            break
//        }
//
//        return header
//    }
//}
//
//extension HomeVC {
//    func playMainMovie(item: AVPlayerItem, movie: Movie) {
//        let sb = UIStoryboard(name: "Player", bundle: nil)
//        DispatchQueue.main.async {
//            guard let vc = sb.instantiateViewController(withIdentifier: "PlayerViewVC") as? PlayerViewVC else { return }
//
//            vc.modalPresentationStyle = .fullScreen
//            vc.player.replaceCurrentItem(with: item)
//            vc.movieInfo = movie
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//}
//
//
