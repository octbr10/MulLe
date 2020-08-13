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
    }
    
    override func prepare(for seque:UIStoryboardSegue, sender: Any?) {
//        if let vc = seque.destination as? FolderViewController, seque.identifier == "homeToFolder" {
//            vc.delegate = self
            
        if let vc = seque.destination as? FolderViewController {
            vc.delegate = self
            print("delegate set in Now Playing View Controller")
        }
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

extension NowPlayingViewController: ChildToParentProtocol {
    func buttonClickedByUser() {
            
    }
    func  needToPassInforToParent(with : [Folder]) {
        folders = with
        print("NowPlayingViewController folders", folders!)

    }
}
