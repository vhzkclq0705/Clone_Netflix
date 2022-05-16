//
//  SaveCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/15.
//

import UIKit
import Kingfisher

class SavedCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImage.layer.cornerRadius = 5
        thumbnailImage.contentMode = .scaleAspectFill
    }
    
    func updateUI(_ movie: Movie) {
        let url = URL(string: movie.thumbnailPath)!
        thumbnailImage.kf.setImage(with: url)
        titleLabel.text = movie.title
        directorLabel.text = movie.director
    }
}
