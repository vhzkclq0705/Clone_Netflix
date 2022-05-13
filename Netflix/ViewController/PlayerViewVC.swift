//
//  PlayerViewVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/13.
//

import UIKit
import AVFoundation

class PlayerViewVC: UIViewController {

    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    let player = AVPlayer()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playState()
    }
}

extension PlayerViewVC {
    @IBAction func playButtonTapped(_ sender: Any) {
        if player.isPlaying {
            pauseState()
        } else {
            playState()
        }
    }
    
    @IBAction func cancleButtonTapped(_ sender: Any) {
        reset()
        dismiss(animated: true)
    }

    func playState() {
        player.play()
        playButton.isSelected = true
    }
    
    func pauseState() {
        player.pause()
        playButton.isSelected = false
    }

    func reset() {
        pauseState()
        player.replaceCurrentItem(with: nil)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
