//
//  FolderManager.swift
//  MulLe
//
//  Created by Jeeyoung Park on 05.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    var playbackType = PlaybackType.Normal
    var isPlaying = false
    var avAudioPlayer: AVAudioPlayer?
    var currentAudio: URL?
    
    func startPlayback (audio: URL) {
        
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    
      
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: audio)
            avAudioPlayer?.delegate = self
            avAudioPlayer?.play()
            playbackType = .Normal
            currentAudio = audio
            isPlaying = true
            
        } catch {
            print("Playback failed.")
        }

    }
    
    func newRecordPlayback(audio:URL) {
        let audioURL = audio
        startPlayback(audio: audioURL)
        playbackType = .NewRecord
    }
    
    func reRecordPlayback(audio:URL) {
        let audioURL = audio
        startPlayback(audio: audioURL)
        playbackType = .ReRecord
    }
    
    func stopPlayback() {
        avAudioPlayer?.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false

        switch playbackType {
            case .Normal:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil, userInfo: ["playbackType": "Normal", "audioURL": currentAudio!])
            case .NewRecord:
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil, userInfo: ["playbackType": "NewRecord", "audioURL": currentAudio!])
            case .ReRecord:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil,userInfo: ["playbackType": "ReRecord", "audioURL": currentAudio!])
        }
    }
    
}
