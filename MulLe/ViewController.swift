//
//  ViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 15.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{

    var avAudioPlayer: AVAudioPlayer?
    var avQueuePlayer: AVQueuePlayer?
    var audioPlayer:  AudioPlayer?
    var audioRecorder: AudioRecorder?
    
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playAllButton: UIButton!
    
    let cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        audioRecorder = AudioRecorder()
        audioPlayer = AudioPlayer()
    }
    
    @IBAction func touchUpRecordButton(_ sender: UIButton) {
        if audioRecorder?.isRecording == false {
            audioRecorder!.startRecording()
            recordButton.setTitle("Stop", for: .normal)
            self.tableView.reloadData()
            //self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
        } else {
            recordButton.setTitle("Record", for: .normal)
            audioRecorder!.stopRecording()
//            let lastURL = audioRecorder!.stopRecording()
//            if var urlToPlay = lastURL {
//                print(urlToPlay)
//                let audioPlayer = AudioPlayer()
//                urlToPlay = audioRecorder!.recordings[0].fileURL
//                print(urlToPlay)
//                audioPlayer.startPlayback(audio: urlToPlay, owner: self)
//            }
            self.tableView.reloadData()
           // audioPlayer.startPlayback(audio: audioRecorder?.recordings[0].fileURL, owner: self)
//            self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
        }
    }
    
    @IBAction func playAllAudios(_ sender: UIButton) {
        
        var audioPlayerItems: [AVPlayerItem] = []
        
        for item in audioRecorder!.recordings {
            let url = item.fileURL
            let audioPlayerItem = AVPlayerItem(url: url)
            audioPlayerItems.append(audioPlayerItem)
        }
        
        avQueuePlayer = AVQueuePlayer(items: audioPlayerItems)
        avQueuePlayer?.play()
  }
    
    
    @IBAction func editList(_ sender: UIBarItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done": "Edit"
        
    }
    
}


// Mark: - UITableViewCell 정의

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioRecorder?.recordings.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        cell.audioURL = audioRecorder!.recordings[indexPath.row].fileURL
        cell.myTableViewController = self
        cell.sequenceNo.text = String(audioRecorder!.recordings.count - indexPath.row)
        
        cell.timeRecorded.text = String(audioRecorder!.recordings[indexPath.row].createdAt.toStringLocalTime(dateFormat: "YY-MM-dd HH:mm:ss"))
        
  
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: cell.audioURL)
            let duration = CGFloat(avAudioPlayer!.duration)
            let stringDuration = String(format: "%.2f", Double(duration))
            cell.audioDuration.text = stringDuration + " s"
           
        } catch {}  
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = audioRecorder!.recordings[sourceIndexPath.item]
        audioRecorder!.recordings.remove(at: sourceIndexPath.item)
        audioRecorder!.recordings.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            audioRecorder!.deleteAudioFile(urlsToDelete: (audioRecorder!.recordings[indexPath.row].fileURL))
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
  
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            
//            for itemq in audioRecorder!.recordings {
//                print (itemq)
//            }
//            print("deletionIndexPath: ", deletionIndexPath[1])
//            print("audioRecorder!.recordings.count: ", audioRecorder!.recordings.count)
//            print(audioRecorder!.recordings[deletionIndexPath[1]].fileURL)
            
            audioRecorder!.deleteAudioFile(urlsToDelete: audioRecorder!.recordings[deletionIndexPath[1]].fileURL)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)

        }
    }
   
}

