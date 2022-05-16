//
//  SearchVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/09.
//

import UIKit
import Kingfisher
import AVFoundation

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfMovies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        
        cell.thumbnailImage.kf.setImage(with: viewModel.showThumbnail(indexPath.item))
        
        return cell
    }
}

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Player", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PlayerViewVC") as? PlayerViewVC else { return }
        
        vc.modalPresentationStyle = .fullScreen
        vc.player.replaceCurrentItem(with: viewModel.playMovie(indexPath.item))
        vc.movieInfo = viewModel.searchMovies[indexPath.item]
        present(vc, animated: true, completion: nil)
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 8
        let itemSapcing: CGFloat = 10
        
        let width = (collectionView.bounds.width - margin * 2 - itemSapcing * 2) / 3
        let height = width * 10 / 7
        
        return CGSize(width: width, height: height)
    }
}

extension SearchVC: UISearchBarDelegate {
    // 키보드를 내려가게 하는 함수
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    // 검색을 끝냈을 때 실행되는 함수
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        if let searchTerm = searchBar.text, searchTerm.isEmpty == false {
            viewModel.searchMovies(searchTerm) { [weak self] in
                DispatchQueue.main.async {
                    self?.searchCollectionView.reloadData()
                }
            }
        }
        
    }
}
