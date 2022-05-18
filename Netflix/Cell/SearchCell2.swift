//
//  SearchCell2.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit
import Kingfisher

class SearchCell2: UICollectionViewCell {

    static let identifier = "searchCell"
    
    let thumbnailImage = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

extension SearchCell2 {
    func setup() {
        contentView.addSubview(thumbnailImage)
        
        thumbnailImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI(_ movie: Movie) {
        let url = URL(string: movie.thumbnailPath)!
        thumbnailImage.kf.setImage(with: url)
    }
}