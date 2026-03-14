//
//  DDAudioPlayerView.swift
//  easyart
//
//  Created by Damon on 2024/9/29.
//

import UIKit
import DDUtils

class DDAudioPlayerView: DDView {
    private(set) var mAudioTool = DDAudioTools()
    private var mTimer: Timer?
    private var mTotalTime: TimeInterval = 0
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mBGView)
        mBGView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        mContentView.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        mContentView.addSubview(mCurrentTimeLabel)
        mCurrentTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.greaterThanOrEqualTo(60)
            make.top.equalTo(mCloseButton.snp.bottom).offset(24)
        }
        
        mContentView.addSubview(mTotalTimeLabel)
        mTotalTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.width.greaterThanOrEqualTo(60)
            make.centerY.equalTo(mCurrentTimeLabel)
        }
        
        mContentView.addSubview(mSlider)
        mSlider.snp.makeConstraints { make in
            make.left.equalTo(mCurrentTimeLabel.snp.right)
            make.right.equalTo(mTotalTimeLabel.snp.left)
            make.centerY.equalTo(mTotalTimeLabel)
        }
        
        mContentView.addSubview(mPlayButton)
        mPlayButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mSlider.snp.bottom).offset(35)
            make.width.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0x000000, alpha: 0.4)
        return view
    }()
    
    lazy var mContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        return view
    }()
    
    lazy var mCloseButton: DDButton = {
        let button = DDButton()
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "home_audio_arrow")
        button.imageSize = CGSize(width: 8, height: 5)
        return button
    }()
    lazy var mCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mTotalTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeColor.gray.color()
        return label
    }()

    lazy var mSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage.dd.getImage(color: ThemeColor.main.color(), size: CGSizeMake(4, 7)), for: .normal)
        return slider
    }()
    
    lazy var mPlayButton: DDButton = {
        let button = DDButton()
        button.contentType = .center(gap: 0)
        button.imageSize = CGSize(width: 45, height: 45)
        button.normalImage = UIImage(named: "home_audio_play")
        button.selectedImage = UIImage(named: "home_audio_stop")
        return button
    }()
}

extension DDAudioPlayerView {
    func _bindView() {
        _ = self.mAudioTool.audioPublish.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            self.mPlayButton.isSelected = status == .playing || status == .resume
        })
        
        _ = self.mPlayButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.mPlayButton.isSelected {
                self._pause()
            } else {
                self._startPlay(isResume: true)
            }
        })
        
        _ = self.mSlider.rx.value.subscribe(onNext: { [weak self] progress in
            guard let self = self else { return }
            self.mAudioTool.audioPlayer?.currentTime = self.mTotalTime * Double(progress)
            self._updateTime()
        })
        
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        })
        
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        })
        self.mBGView.addGestureRecognizer(tap)
    }
    
    func _updateTime() {
        let currentTime = self.mAudioTool.audioPlayer?.currentTime ?? 0
        self.mCurrentTimeLabel.text = self._formate(time: currentTime)
        self.mSlider.setValue(Float(currentTime/self.mTotalTime), animated: false)
        if ceil(currentTime + 1) >= self.mTotalTime {
            self._stopPlay()
        }
    }
    
    func _startPlay(isResume: Bool = false) {
        if isResume {
            self.mAudioTool.resume()
        } else {
            self.mAudioTool.playMusic()
        }
        self.mTimer?.invalidate()
        self.mTimer = Timer(timeInterval: 1, repeats: true, block: { _ in
            self._updateTime()
        })
        RunLoop.main.add(self.mTimer!, forMode: .default)
    }
    
    func _pause() {
        self.mAudioTool.pauseMusic()
        self.mTimer?.invalidate()
    }
    
    func _stopPlay() {
        self.mAudioTool.pauseMusic()
        self.mTimer?.invalidate()
        self.mAudioTool.audioPlayer?.currentTime = 0
        self.mCurrentTimeLabel.text = "00:00"
        self.mSlider.setValue(0, animated: false)
    }
    
    func _formate(time: TimeInterval) -> String {
        let minute = String(format: "%02d", Int(ceil(time))/60)
        let second = String(format: "%02d", Int(ceil(time))%60)
        return minute + ":" + second
    }
}

extension DDAudioPlayerView {
    func prepare(url: String) {
        self.mAudioTool.prepare(url: URL(string: url))
        self._stopPlay()
    }
    
    func show(play: Bool) {
        if self.mAudioTool.audioPlayer?.isPlaying == true {
            //仅显示
        } else {
            self.mTotalTime = self.mAudioTool.audioPlayer?.duration ?? 0
            self.mTotalTimeLabel.text = self._formate(time: self.mTotalTime)
            if play {
                self._startPlay()
            }
        }
        self.isHidden = false
    }
    
    func hide() {
//        self._stopPlay()
//        self.mTimer?.invalidate()
//        DDPopView.hide()
        self.isHidden = true
    }
    
}
