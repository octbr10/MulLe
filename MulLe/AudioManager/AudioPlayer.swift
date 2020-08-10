//
//  FolderManager.swift
//  MulLe
//
//  Created by Jeeyoung Park on 05.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import SwiftUI
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    var isPlaying = false
    var audioPlayer: AVAudioPlayer!
    var currentAudio: URL?
    
    func startPlayback (audio: URL) {
        
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    
      
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
            currentAudio = audio
        } catch {
            print("Playback failed.")
        }

    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil, userInfo: ["audioURL": currentAudio as Any])
        isPlaying = false
        NotificationCenter.default.removeObserver(self)
        
        
    }
    
}
