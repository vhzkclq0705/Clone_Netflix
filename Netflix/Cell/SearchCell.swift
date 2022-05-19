//
//  SearchCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {

    static let identifier = "searchCell"
    
    let thumbnailImage = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

extension SearchCell {  // About UI Setup
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
