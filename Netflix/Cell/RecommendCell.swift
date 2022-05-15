//
//  RecommendCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/15.
//

import UIKit

class RecommendCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    
    func updateUI(movie: RecommendMovie) {
        thumbnailImage.image = movie.thmbnail
    }
}
