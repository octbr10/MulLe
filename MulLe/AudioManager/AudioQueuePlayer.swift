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
    var audioItems: [AVPlayerItem] = []
    var audioItemsCount = 0
    var isPlaying = false
    //let owner: AVAudioPlayerDelegate!

    init (items: [URL]) {
        //self.owner = owner
        for item in items {
            let audioItem = AVPlayerItem(url: item)
            audioItems.append(audioItem)
        }
        audioItemsCount = audioItems.count
    }
    
    func startPlayback() {
      NotificationCenter.default.addObserver(self, selector: #selector(self.qPlayerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
      
      audioQueuePlayer = AVQueuePlayer(items: audioItems)
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
        if audioItemsCount == 1 {
            print("all itmes are played.")
            isPlaying = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qPlayerDidFinishPlaying"), object: nil)
        } else {
            audioItemsCount -= 1
            print(audioItemsCount)
        }
    }

}
