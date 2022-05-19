//
//  SavedCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit
import Kingfisher
import SnapKit

class SavedCell: UITableViewCell {

    static let identifier = "searchCell"
    
    lazy var thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

extension SavedCell {   // About UI Setup
    func setup() {
        [thumbnailImage, titleLabel, directorLabel].forEach { contentView.addSubview($0) }
        
        thumbnailImage.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(250)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImage.snp.top)
            $0.left.equalTo(thumbnailImage.snp.right).offset(20)
            $0.right.equalToSuperview().inset(10)
        }
        
        directorLabel.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailImage.snp.bottom)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    func updateUI(_ movie: Movie) {
        let url = URL(string: movie.thumbnailPath)!
        thumbnailImage.kf.setImage(with: url)
        titleLabel.text = movie.title
        directorLabel.text = movie.director
    }
}
