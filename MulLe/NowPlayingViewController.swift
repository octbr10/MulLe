//
//  NowPlayingViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 12.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    var folderManager: FolderManager?
    var recordFileManager: RecordFileManager?
    var audioQueuePlayer: AudioQueuePlayer?
    
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var folders: [Folder]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        folderManager = FolderManager()
        // Do any additional setup after loading the view.
        
        
      NotificationCenter.default.addObserver(self, selector: #selector(testprint), name: NSNotification.Name(rawValue: "qPlayerDidFinishPlaying"), object: nil)
        
        
        
    }
    var count = 0
    
    @objc func testprint() {
        count = count + 1
        print("count: ", count)
        folderName.text = String(count)
        
    }
    
    override func prepare(for seque:UIStoryboardSegue, sender: Any?) {
//        if let vc = seque.destination as? FolderViewController, seque.identifier == "homeToFolder" {
//            vc.delegate = self

    }
    
    
    @IBAction func playAllAudios(_ sender: UIButton) {
        
        //needToPassInforToParent(with : [Folder])
        
//          if  audioQueuePlayer?.isPlaying == true{
//              audioQueuePlayer?.stopPlayback()
//              playButton.setTitle("Play", for: .normal)
//          } else {
//              var urls: [URL] = []
//              for item in recordFileManager!.recordings {
//                  let url = item.fileURL
//                  //print("url", url)
//                  urls.append(url)
//                  }
//              playButton.setTitle("Stop", for: .highlighted)
//              audioQueuePlayer = AudioQueuePlayer(items: urls)
//              audioQueuePlayer?.startPlayback()
//          }
      
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


