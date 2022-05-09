//
//  SearchVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/09.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        
        return cell
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
        
        // 검색어가 있는지 확인
        guard let searchText = searchBar.text, searchText.isEmpty == false else { return }
        
        // 네트워킹을 통한 검색
        
        
        print("--> 입력한 검색어: \(searchText)")
    }
}
