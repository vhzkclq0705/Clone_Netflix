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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var movieSlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    
    var savedViewModel = SavedViewModel.shared
    var movieInfo: Movie?
    let player = AVPlayer()
    // 슬라이더 업데이터를 감지하는 감시자
    var timeObserver: Any?
    var timer: Timer?
    
    // 가로 모드로 설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player
        titleLabel.text = movieInfo?.title
        setupSaveButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playState()
        setupPlayer()
        resetTimer()
    }
}

// 재생 관련 버튼 함수
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
    
    @IBAction func jumpForward(_ sender: Any) {
        timeJump(10)
    }
    
    @IBAction func jumpBackward(_ sender: Any) {
        timeJump(-10)
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
    
    func timeJump(_ sec: Double) {
        let currentTime = player.currentTime()
        let timeJump = CMTimeGetSeconds(currentTime).advanced(by: sec)
        let seekTime = CMTime(value: CMTimeValue(timeJump), timescale: 1)
        player.seek(to: seekTime)
    }
}

// 진행 상태(슬라이더, 남은 시간) 함수
extension PlayerViewVC {
    @IBAction func adjustMovieSlider(_ sender: Any) {
        // 영화의 전체 시간
        guard let duration = player.currentItem?.duration else { return }
        // 전체 시간을 초 단위로 변경한 후, 슬라이더의 value와 곱해준다.
        // 곱하는 이유: thumb 위치의 value 값으로 영상의 재생 위치를 변경시켜주기 위해서
        let value = Float64(movieSlider.value) * CMTimeGetSeconds(duration)
        // value를 seekTime(현재 시간)에 대입
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        // player의 현재 시간을 seekTime으로 변경
        player.seek(to: seekTime)
    }
    
    func setupPlayer() {
        let interval = CMTime(value: 1, timescale: 10)
        // 시간이 interval만큼 지날 때 마다 updateMovieState 호출(슬라이더와 남은 시간 변경)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] currentTime in
            self?.updateMovieState(currentTime) })
    }
    
    func updateMovieState(_ currentTime: CMTime) {
        // 현재 시간을 초 단위로 변경
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        
        // 현재 재생되는 아이템(영상)이 있는지 확인
        if let currentItem = player.currentItem {
            // 영상의 전체 시간
            let duration = currentItem.duration
            // 전체 시간을 초 단위로 변경
            let totalTimeInSeconds = CMTimeGetSeconds(duration)
            // 시간이 유효한지 검사
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            // 슬라이더의 value를 현재 시간에 맞는 값으로 변경시킨다.
            // 시간이 지남에 따라 thumb의 위치가 점점 오른쪽으로 이동한다.
            // 또는, tumb를 이동 시키면 해당 value에 맞는 시간대로 영상 위치를 이동시킨다.
            movieSlider.value = Float(currentTimeInSeconds / totalTimeInSeconds)
            
            // 남은 시간 (전체 시간 - 현재 시간)
            let timeRemaining = totalTimeInSeconds - currentTimeInSeconds
            // 남은 시간을 분 단위와 초 단위로 바꿔줌
            let mins = timeRemaining / 60
            let secs = timeRemaining.truncatingRemainder(dividingBy: 60)
            // NumberFomatter를 통해 자릿수를 최대 2개로, 소수는 없애준다.
            let timeFormatter = NumberFormatter()
            timeFormatter.minimumIntegerDigits = 2
            timeFormatter.minimumFractionDigits = 0
            timeFormatter.roundingMode = .down
            
            guard let minsStr = timeFormatter.string(from: NSNumber(value: mins)),
                  let secsStr = timeFormatter.string(from: NSNumber(value: secs)) else { return }
            
            timeRemainingLabel.text = "\(minsStr):\(secsStr)"
        }
    }
}

// Control View에 대한 함수
extension PlayerViewVC {
    // Control View가 안보면 보이게, 보인다면 안보이게 한다.
    @IBAction func recognizeTapped(_ sender: Any) {
        controlView.isHidden = !controlView.isHidden
        resetTimer()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let movie = movieInfo {
            if saveButton.isSelected {
                savedViewModel.deleteMovie(movie)
            } else {
                savedViewModel.addMovie(movie)
            }
        }
        saveButton.isSelected = !saveButton.isSelected
    }
    
    func setupSaveButton() {
        saveButton.isSelected = savedViewModel.checkMovie(movieInfo!)
    }
    
    func resetTimer() {
        // 타이머가 있다면 타이머를 제거한다.
        timer?.invalidate()
        // 영상을 탭 하면, 5초 뒤 컨트롤뷰가 사라진다.
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideControlView), userInfo: nil, repeats: false)
    }
    
    @objc func hideControlView() {
        controlView.isHidden = true
        resetTimer()
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
