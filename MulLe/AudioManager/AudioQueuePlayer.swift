//
//  AudioQueuePlayer.swift
//  MulLe
//
//  Created by Jeeyoung Park on 27.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//
//import Foundation
//import UIKit
import AVFoundation

class AudioQueuePlayer: NSObject{
        
    static let shared = AudioQueuePlayer()
    var audioQueuePlayer: AVQueuePlayer?
    var audioItems: [AVPlayerItem] = []
    var audioItemsCount = 0
    var isPlaying = false
    //let owner: AVAudioPlayerDelegate!
    
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.qPlayerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        audioQueuePlayer = AVQueuePlayer(items: audioItems)
    }
 
//    init (items: [URL]) {
//
//       audioItems = []
//        //self.owner = owner
//        for item in items {
//            let audioItem = AVPlayerItem(url: item)
//            audioItems.append(audioItem)
//        }
//        audioItemsCount = audioItems.count
//
//      super.init()
//      NotificationCenter.default.addObserver(self, selector: #selector(self.qPlayerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//      //
//    }
     
    func startPlayback(item:URL){
        let items = [item]
        startPlayback(items: items)
        
    }
    
    func startPlayback(items:[URL]) {

        // playing when silentmode
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        if isPlaying == true {
            stopPlayback()
            

            print("avqplayer is playing")
        } else {
            print("avqplayer is not playing")
        }
        
        for item in items {
            let audioItem = AVPlayerItem(url: item)
            audioItems.append(audioItem)
        }

        audioItemsCount = audioItems.count
        audioQueuePlayer = AVQueuePlayer(items: audioItems)
        audioQueuePlayer?.play()
        print("audioQPlay starts")
        isPlaying = true
        print(isPlaying)
    }

    func stopPlayback() {
        audioQueuePlayer?.pause()

        audioQueuePlayer?.removeAllItems()
        audioItems = []
        
        
        
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
