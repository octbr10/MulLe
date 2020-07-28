//
//  ViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 15.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController{

    var avAudioPlayer: AVAudioPlayer?
    var audioPlayer:  AudioPlayer?
    var audioRecorder: AudioRecorder?
    var audioQueuePlayer: AudioQueuePlayer?
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playAllButton: UIButton!
    
    let cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        audioRecorder = AudioRecorder()
        audioPlayer = AudioPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayAllButton), name: NSNotification.Name(rawValue: "qPlayerDidFinishPlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetButtons), name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil)
    }
  
    @objc func resetPlayAllButton() {
        playAllButton.setTitle("Play all", for: .normal)
    }
    
    @objc func resetButtons() {
        tableView.reloadData()
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
            self.tableView.reloadData()
            playNewRecord()
        }
    }
    
    func playNewRecord() {
        let url = audioRecorder!.recordings[0].fileURL
        audioQueuePlayer = AudioQueuePlayer(items: [url])
        audioQueuePlayer!.startPlayback()
    }
    
    @IBAction func playAllAudios(_ sender: UIButton) {
        if audioQueuePlayer?.isPlaying == true{
            audioQueuePlayer!.stopPlayback()
            playAllButton.setTitle("Play all", for: .normal)
        } else {
            
            var urls: [URL] = []
            for item in audioRecorder!.recordings {
                let url = item.fileURL
                print("url", url)
                urls.append(url)
                }
            audioQueuePlayer = AudioQueuePlayer(items: urls)
            playAllButton.setTitle("Stop", for: .normal)
            audioQueuePlayer!.startPlayback()
        }
    
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
        
        cell.reRecordButton.isEnabled = true
        cell.playButton.setTitle("Play", for: .normal)
        
        
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
  
    @objc func deleteCell(cell: UITableViewCell) {
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

