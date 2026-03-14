//
//  DDAudioTools.swift
//  HiTalk
//
//  Created by Damon on 2024/5/31.
//

import UIKit
import Foundation
import AVFoundation
import RxRelay
import DDUtils

enum AudioPlayingStatus {
    case playing
    case resume
    case stop
    case error
}

class DDAudioTools: NSObject {
    let audioPublish = PublishRelay<AudioPlayingStatus>()
    private(set) var audioPlayer: AVAudioPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    //播放速度
    var rate: Float = 1 {
        didSet {
            self.audioPlayer?.rate = rate
        }
    }
    //播放音量, nil是为系统音量
    var volume: Float? {
        didSet {
            self.audioPlayer?.volume = volume ?? audioSession.outputVolume
        }
    }
}

extension DDAudioTools {
    /// 准备音乐
    /// - Parameters:
    ///   - url: 文件地址
    ///   - repeated: 是否重复播放
    ///   - audioSessionCategory: 播放模式 .playback 扬声器播放，.playAndRecord听筒模式
    func prepare(url: URL?, repeated: Bool = false, audioSessionCategory: AVAudioSession.Category = AVAudioSession.Category.playback) {
        guard var musicURL = url else { return }
        
        if musicURL.absoluteString.hasPrefix("http://") || musicURL.absoluteString.hasPrefix("https://") {
            guard let name = musicURL.path.dd.hashString(hashType: .md5) else { return }
            let path = DDUtils.shared.createFileDirectory(in: .caches, directoryName: "music").appendingPathComponent(name, isDirectory: false)
            if let audioData = try? Data(contentsOf: musicURL) {
                try? audioData.write(to: path)
                musicURL = path
                self.prepare(data: try? Data(contentsOf: musicURL))
            }
        } else {
            self.prepare(data: try? Data(contentsOf: musicURL))
            
        }
//        if musicURL.absoluteString.hasPrefix("http://") || musicURL.absoluteString.hasPrefix("https://") {
//            guard let name = musicURL.path.dd.hashString(hashType: .md5) else { return }
//            let path = DDUtils.shared.createFileDirectory(in: .caches, directoryName: "music").appendingPathComponent(name, isDirectory: false)
//            if let audioData = try? Data(contentsOf: musicURL) {
//                DispatchQueue.main.async {
//                    try? audioData.write(to: path)
//                    musicURL = path
//                    self.prepare(data: try? Data(contentsOf: musicURL))
//                }
//            }
//        } else {
//            self.prepare(data: try? Data(contentsOf: musicURL))
//        }
    }
    
    ///准备音乐
    func prepare(data: Data?, repeated: Bool = false, audioSessionCategory: AVAudioSession.Category = AVAudioSession.Category.playback) {
        guard let data = data else { return }
        audioPlayer?.stop()
        //设置模式
        try? audioSession.setCategory(audioSessionCategory)
        try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.init())

        audioPlayer = try? AVAudioPlayer(data: data)
        audioPlayer?.enableRate = true
        audioPlayer?.delegate = self
        audioPlayer?.volume = self.volume ?? audioSession.outputVolume
        audioPlayer?.rate = self.rate
        if repeated {
            audioPlayer?.numberOfLoops = -1
        } else {
            audioPlayer?.numberOfLoops = 0
        }
        audioPlayer?.prepareToPlay()
    }
    
    ///播放音乐
    func playMusic() {
        self.audioPublish.accept(.playing)
        self.audioPlayer?.play()
    }
    
    ///关闭音乐播放
    func pauseMusic() -> Void {
        audioPlayer?.pause()
        self.audioPublish.accept(.stop)
    }
    
    ///恢复播放
    func resume() -> Void {
        self.audioPlayer?.play()
        self.audioPublish.accept(.resume)
    }
    
    ///停止并释放音乐播放资源
    func invalidateMusic() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
}

extension DDAudioTools: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioPublish.accept(.stop)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.audioPublish.accept(.error)
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        self.audioPublish.accept(.error)
    }
}
