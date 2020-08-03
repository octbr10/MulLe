//AudioPlayer.swift

//Created by BLCKBIRDS on 29.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation
import UIKit
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate{
  
    var isPlaying = false
    
    var audioPlayer: AVAudioPlayer!
   
    func startPlayback (audio: URL) {
        print("starting playback...")
        
        // playing via Speaker instead of phone call mode
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
        print("startPlayback funciton ends here")
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil)
            print("audioPlayerDidFinishPlaying is called")
        } else {print("playbackfinishing failed")}
    }
}
