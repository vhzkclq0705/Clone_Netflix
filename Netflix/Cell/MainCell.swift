//
//  MainCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/15.
//

import UIKit
import AVFoundation
import SnapKit
import SwiftUI

class MainCell: UICollectionViewCell {

    static let identifier = "mainCell"
    
    var playButtonTapHandler: ((AVPlayerItem, Movie) -> Void)?
    
    lazy var thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "play.fill",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        config.title = "   재생"
        
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.tintColor = .black
        button.backgroundColor = .white
        button.configuration = config
        button.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var plusButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        config.title = "내가 찜한 콘텐츠"
        config.imagePlacement = .top
        
        let button = UIButton()
        button.tintColor = .white
        button.configuration = config
        
        return button
    }()
    
    lazy var infoButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "info.circle",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        config.title = "정보"
        config.imagePlacement = .top
        
        let button = UIButton()
        button.tintColor = .white
        button.configuration = config
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }

}

extension MainCell {    // About UI Setup
    func setup() {
        [thumbnailImage, plusButton, playButton, infoButton]
            .forEach { contentView.addSubview($0) }
        
        thumbnailImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
        
        playButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        plusButton.snp.makeConstraints {
            $0.height.equalTo(playButton)
            $0.right.equalTo(playButton.snp.left).inset(-5)
            $0.top.equalTo(playButton)
        }
        
        infoButton.snp.makeConstraints {
            $0.height.equalTo(playButton)
            $0.left.equalTo(playButton.snp.right).offset(40)
            $0.top.equalTo(playButton)
        }
    }
    
    func updateUI(_ movie: RecommendMovie) {
        thumbnailImage.image = UIImage(named: "img_header")
    }
}

extension MainCell {    // About Cell Button Action
    @objc func playButtonTapped(_ sender: UIButton) {
        SearchAPI.search("interstellar") { movies in
            guard let interstellar = movies.first else { return }
            
            let url = URL(string: interstellar.previewURL)!
            let item = AVPlayerItem(url: url)
            self.playButtonTapHandler?(item, interstellar)
        }
    }
}
