//
//  MainCell.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/15.
//

import UIKit
import AVFoundation

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var playButtonTapHandler: ((AVPlayerItem, Movie) -> Void)?
    var plusButtonTapHandler: (() -> Void)?
    var infoButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.layer.cornerRadius = 5
        // image를 imageView에 꽉 채우도록 설정
        thumbnailImage.contentMode = .scaleAspectFill
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        SearchAPI.search("interstellar") { movies in
            guard let interstellar = movies.first else { return }
            
            let url = URL(string: interstellar.previewURL)!
            let item = AVPlayerItem(url: url)
            self.playButtonTapHandler?(item, interstellar)
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        // save the movie to Saved Contents
        plusButtonTapHandler?()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        // present the movie's information
        infoButtonTapHandler?()
    }
    
    func checkSaved() {
        
    }
}
