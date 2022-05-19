//
//  RecommendCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit

class RecommendCell: UICollectionViewCell {

    static let identifier = "recommendCell"
    
    let thumbnailImage = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

extension RecommendCell {   // About UI Setup
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
