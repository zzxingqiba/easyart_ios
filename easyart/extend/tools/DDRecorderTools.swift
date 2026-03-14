//
//  DDRecorderTools.swift
//  HiTalk
//
//  Created by Damon on 2024/6/4.
//

import UIKit
import AVFoundation
import DDUtils

import DDLoggerSwift
import RxSwift

class DDRecorderTools: NSObject {
    private var audioRecorder: AVAudioRecorder?
    let mCompleteSubject = PublishSubject<URL?>()
    let audioFileName = DDUtils.shared.getFileDirectory(type: .tmp).appendingPathComponent("record.mp4")
    var mStopTimer: Timer?
    
    static let shared: DDRecorderTools = {
        let tShared = DDRecorderTools()
        return tShared
    }()
}

extension DDRecorderTools {
    
    func startRecord() {
        if FileManager.default.fileExists(atPath: self.audioFileName.path) {
           try? FileManager.default.removeItem(at: self.audioFileName)
        }
        let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)
                audioSession.requestRecordPermission { [weak self] allowed in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if allowed {
                            self._record()
                        } else {
                            let pop = HDWarnView(title: "Tips", content: "Media is not supported or not authord on this Mobile.")
                            pop.mRightButton.setTitle("Author", for: .normal)
                            _ = pop.clickEvent.emit(onNext: { clickInfo in
                                HDPopView.hide()
                                if clickInfo.clickType == .confirm {
                                    DDUtils.shared.openSystemSetting()
                                }
                            })
                            HDPopView.show(view: pop)
                        }
                    }
                }
            } catch {
                self.mCompleteSubject.onNext(nil)
                // Handle setup errors
                printError(error.localizedDescription)
            }
    }
    
    func stopRecord() {
        self.mStopTimer?.invalidate()
        self.audioRecorder?.stop()
        self.mCompleteSubject.onNext(audioFileName)
    }
}

private extension DDRecorderTools {
    func _record() {
        mStopTimer?.invalidate()
        mStopTimer = Timer(timeInterval: 60, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            self.stopRecord()
        })
        
        let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.record()
        } catch {
            self.mCompleteSubject.onNext(nil)
            printError(error.localizedDescription)
        }
    }
}
