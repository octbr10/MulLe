//
//  AudioQueuePlayer.swift
//  MulLe
//
//  Created by Jeeyoung Park on 27.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

class AudioQueuePlayer: NSObject{
        
    var audioQueuePlayer: AVQueuePlayer!
    var audioItems: [AVPlayerItem]
    var audioItemsCount = 0
    var isPlaying = false
    //let owner: AVAudioPlayerDelegate!

    init (items: [URL]) {

       audioItems = []
        //self.owner = owner
        for item in items {
            let audioItem = AVPlayerItem(url: item)
            audioItems.append(audioItem)
        }
        audioItemsCount = audioItems.count
      
      super.init()
      NotificationCenter.default.addObserver(self, selector: #selector(self.qPlayerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
     
    func startPlayback() {
    

      
      audioQueuePlayer = AVQueuePlayer(items: audioItems)
      
      // playing via Speaker instead of phone call mode
      let playbackSession = AVAudioSession.sharedInstance()
      do {
        try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
      } catch {
        print("Playing over the device's speakers failed")
        }
             
      audioQueuePlayer.play()
      print("audioQPlay starts")
      isPlaying = true
      print(isPlaying)
    }

    func stopPlayback() {
        audioQueuePlayer.pause()
        print("Stop is clicked")
        isPlaying = false
        print(isPlaying)
    }
    
    @objc func qPlayerDidFinishPlaying(sender: Notification) {
        print("qPlayerDidFinishPlaying audioItemsCount: ", audioItemsCount)
        audioItemsCount = audioItemsCount - 1
        if audioItemsCount == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qPlayerDidFinishPlaying"), object: nil)
            isPlaying = false
            NotificationCenter.default.removeObserver(self)
        }
    }
}
