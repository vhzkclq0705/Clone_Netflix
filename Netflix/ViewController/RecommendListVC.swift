//
//  RecommaedListVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/09.
//

import UIKit
import AVFoundation

class RecommendListVC: UIViewController {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}

extension RecommendListVC {
    func updateUI() {
        sectionTitle.text = viewModel.type.title
    }
}

extension RecommendListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RecommendCell else { return UICollectionViewCell() }
        
        let movie = viewModel.item(indexPath.item)
        cell.updateUI(movie: movie)
        
        return cell
    }
}

extension RecommendListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 160)
    }
}
