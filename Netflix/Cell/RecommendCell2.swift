//
//  RecommendCell2.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit

class RecommendCell2: UICollectionViewCell {

    static let identifier = "recommendCell"
    
    let thumbnailImage = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

extension RecommendCell2 {
    func setup() {
        contentView.addSubview(thumbnailImage)
        
        thumbnailImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI(_ movie: RecommendMovie) {
        thumbnailImage.image = movie.thmbnail
    }
}
