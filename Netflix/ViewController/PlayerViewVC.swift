//
//  PlayerViewVC.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/13.
//

import UIKit
import AVFoundation
import SnapKit

class PlayerViewVC: UIViewController {

    var savedViewModel = SavedViewModel.shared
    var movieInfo: Movie?
    let player = AVPlayer()
    // 슬라이더 업데이터를 감지하는 감시자
    var timeObserver: Any?
    var timer: Timer?
    
    lazy var playerView: PlayerView = {
        let view = PlayerView()
        view.backgroundColor = .black
        
        return view
    }()
    
    lazy var controlView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 30)
        config.baseBackgroundColor = UIColor.clear
        
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        button.configuration = config
        button.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage =  UIImage.SymbolConfiguration(pointSize: 25)
        config.baseBackgroundColor = UIColor.clear
        
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .selected)
        button.configuration = config
        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        let button = UIButton()
        button.tintColor = .white
        button.configuration = config
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var jumpSecond1: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    lazy var jumpSecond2: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    lazy var jumpBackwardButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.counterclockwise",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        let button = UIButton()
        button.tintColor = .white
        button.configuration = config
        button.addTarget(self, action: #selector(jumpBackwardButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var jumpForwardButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.clockwise",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        let button = UIButton()
        button.tintColor = .white
        button.configuration = config
        button.addTarget(self, action: #selector(jumpForwardButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "00:00"
        
        return label
    }()
    
    lazy var movieSlider: UISlider = {
        let slider = UISlider()
        // #colorLiteral()을 통해 색상을 코드에서 볼 수 있다.
        slider.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        slider.thumbTintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        slider.addTarget(self, action: #selector(adjustMovieSlider(_:)), for: .valueChanged)
        
        return slider
    }()
    
    lazy var recognizeTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(recognizeTapped(_:)))
        
        return gesture
    }()
    
    // 가로 모드로 설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playState()
        setupPlayer()
        resetTimer()
    }
}

extension PlayerViewVC {    // About UI Setup
    func setupUI() {
        view.addGestureRecognizer(recognizeTapGesture)
        
        [playButton, backButton, saveButton,
         jumpBackwardButton, jumpForwardButton, jumpSecond1, jumpSecond2,
         titleLabel, timeRemainingLabel, movieSlider]
            .forEach { controlView.addSubview($0) }
        
        [playerView, controlView]
            .forEach { view.addSubview($0) }
        
        playerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        controlView.snp.makeConstraints {
            $0.edges.equalTo(playerView)
        }
        
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(10)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(20)
        }
        
        jumpBackwardButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(250)
        }

        jumpForwardButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(250)
        }

        jumpSecond1.snp.makeConstraints {
            $0.centerX.equalTo(jumpBackwardButton)
            $0.top.equalTo(jumpBackwardButton.snp.top).inset(18)
        }

        jumpSecond2.snp.makeConstraints {
            $0.centerX.equalTo(jumpForwardButton)
            $0.top.equalTo(jumpForwardButton.snp.top).inset(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        timeRemainingLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.right.equalToSuperview().inset(10)
        }
        
        movieSlider.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(45)
            $0.left.equalTo(controlView).inset(20)
            $0.right.equalTo(timeRemainingLabel.snp.left).inset(-20)
        }
        
        playerView.player = player
        titleLabel.text = movieInfo?.title
        setupSaveButton()
    }
}

extension PlayerViewVC {    // About Related to Video Play
    @objc func playButtonTapped(_ sender: UIButton) {
        if player.isPlaying {
            pauseState()
        } else {
            playState()
        }
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        reset()
        dismiss(animated: true)
    }
    
    @objc func jumpForwardButtonTapped(_ sender: UIButton) {
        timeJump(10)
    }
    
    @objc func jumpBackwardButtonTapped(_ sender: UIButton) {
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

extension PlayerViewVC {    // About Play State(UISlider, Reamaning Time)
    @objc func adjustMovieSlider(_ sender: UIButton) {
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

extension PlayerViewVC {    // About Control View
    // Control View가 안보면 보이게, 보인다면 안보이게 한다.
    @objc func recognizeTapped(_ sender: Any) {
        controlView.isHidden = !controlView.isHidden
        resetTimer()
    }

    @objc func saveButtonTapped(_ sender: UIButton) {
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

extension AVPlayer {    // AVPlayer Setting
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
