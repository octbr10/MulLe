//
//  AudioQueuePlayer.swift
//  MulLe
//
//  Created by Jeeyoung Park on 27.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
class AudioQueuePlayer: NSObject {
    var audioItem:AVPlayerItem!
    private var playerQueue : AVQueuePlayer?
    // dispatch queue
    let assetQueue = DispatchQueue(label: "randomQueue", qos: .utility)
    let group = DispatchGroup()
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else {
                return
            }
            asynchronouslyLoadURLAsset(newAsset, appendDirectly: false)
        }
    }

    let trackArr:Array<String> = [
        "https://freemusicarchive.org/file/music/ccCommunity/Rotten_Bliss/The_Nightwatchman_Sings/Rotten_Bliss_-_08_-_Timer_Erase.mp3",
        "https://freemusicarchive.org/file/music/no_curator/Magna_Ingress/Bloody_Shadows/Magna_Ingress_-_03_-_The_Hunt_Timegate_Mix.mp3",
        "https://freemusicarchive.org/file/music/WFMU/Lee_Rosevere/Music_To_Wake_Up_To/Lee_Rosevere_-_02_-_Morning_Mist.mp3"
    ]
    
    public func initialize() {
        // load assets as PlayerItems
        self.group.enter()
        var counter = 0;
        for item in self.trackArr {
            if counter > 0 {
                self.assetQueue.async {
                    self.group.wait()
                    self.group.enter()
                    let fileURL = NSURL(string: item)
                    self.asset = AVURLAsset(url: fileURL! as URL, options: nil)
                }
            }
            else {
                self.assetQueue.async {
                    let fileURL = NSURL(string: item)
                    self.asset = AVURLAsset(url: fileURL! as URL, options: nil)
                }
            }
            counter += 1
        }
    }

    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset, appendDirectly:Bool = false) {
        /*
        Using AVAsset now runs the risk of blocking the current thread (the
        main UI thread) whilst I/O happens to populate the properties. It's
        prudent to defer our work until the properties we need have been loaded.
        */
        newAsset.loadValuesAsynchronously(forKeys: self.assetKeysRequiredToPlay) {
            /*
            The asset invokes its completion handler on an arbitrary queue.
            To avoid multiple threads using our internal state at the same time
            we'll elect to use the main thread at all times, let's dispatch
            our handler to the main queue.
            */
            DispatchQueue.main.async {
                /*
                Test whether the values of each of the keys we need have been
                successfully loaded.
                */
                for key in self.assetKeysRequiredToPlay {
                    var error: NSError?
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        self.handleErrorWithMessage(message, error: error)
                        return
                    }
                }
                // We can't play this asset.
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    self.handleErrorWithMessage(message)
                    return
                }
                /*
                We can play this asset. Create a new `AVPlayerItem` and make
                it our player's current item.
                */
                if appendDirectly == false {
                    self.AVItemPool.append(AVPlayerItem(asset: newAsset))
                }
                else {
                    self.AVItemPool.append(AVPlayerItem(asset: newAsset))
                    if self.playerQueue?.canInsert(AVPlayerItem(asset: newAsset), after: self.playerQueue?.items().last) == true {
                        self.playerQueue?.insert(AVPlayerItem(asset: newAsset), after: self.playerQueue?.items().last)
                    }
                }
                self.group.leave()
            }
        }
    }
}
