//
//  SearchVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/09.
//

import UIKit
import AVFoundation
import SnapKit

class SearchVC: UIViewController {
    
    let viewModel = SearchViewModel()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

extension SearchVC {    // About UI Setup
    func setup() {
        [searchBar, collectionView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 8
        let itemSapcing: CGFloat = 10
        
        let width = (view.bounds.width - margin * 2 - itemSapcing * 2) / 3
        let height = width * 10 / 7
        
        layout.itemSize = CGSize(width: width, height: height)
        
        return layout
    }
}

extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate {    // About CollectionView Showing
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfMovies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        
        cell.updateUI(viewModel.movies[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerViewVC()
        
        vc.modalPresentationStyle = .fullScreen
        vc.player.replaceCurrentItem(with: viewModel.playMovie(indexPath.item))
        vc.movieInfo = viewModel.movies[indexPath.item]
        present(vc, animated: true, completion: nil)
    }
}

extension SearchVC: UISearchBarDelegate {   // About SearchBar
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
                    self?.collectionView.reloadData()
                }
            }
        }
        
    }
}
