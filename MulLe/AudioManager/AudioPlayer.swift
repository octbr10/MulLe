//AudioPlayer.swift

//Created by BLCKBIRDS on 29.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation
import UIKit
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
  
    var isPlaying = false
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback (audio: URL, owner: AVAudioPlayerDelegate) {
        print("starting playback...")
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = owner
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
        print("playback is over...")
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
//    func registerDelegate(_ owner: AVAudioPlayerDelegate) {
//        audioPlayer.delegate = owner
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            print("playing is finished")
        }
    }
    
}
