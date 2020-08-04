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

class RecordingViewController: UIViewController{

    var avAudioPlayer: AVAudioPlayer?
    var audioQueuePlayer: AudioQueuePlayer?
    var recordFileManager: RecordFileManager?
    var audioRecorder: AudioRecorder?
   
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playAllButton: UIButton!
    
    let cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.reloadData()
        
        recordFileManager = RecordFileManager()
        audioRecorder = AudioRecorder()

        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayAllButton), name: NSNotification.Name(rawValue: "qPlayerDidFinishPlaying"), object: nil)
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            switch authStatus {  //5
            case .authorized: break
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Speech recognition restricted on this device")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            @unknown default:
                print("Speech recognition auth, unknow error")
            }
        }
    }
  
    @objc func resetPlayAllButton() {
        playAllButton.setTitle("Play all", for: .normal)
        recordFileManager?.fetchRecordings()
        self.tableView.reloadData()
    }
   
    @IBAction func touchDownRecord(_ sender: UIButton) {
                audioRecorder?.startRecording()
    }
    
    @IBAction func touchUpRecordStop(_ sender: UIButton) {
        audioRecorder?.stopRecording()
        recordFileManager?.fetchRecordings()
        

        let lastIndex = recordFileManager!.recordings.endIndex - 1
        let url = recordFileManager!.recordings[lastIndex].fileURL
        
        if audioRecorder?.speechToText(fileURL: url) != "no text recognized" {
            print(audioRecorder?.speechToText(fileURL: url) ?? "no text recognized") //return 값이 "no text recognized" 임
        }
        
        playNewRecord(fileURL: url)

        // scroll to the last row
        self.tableView.reloadData()
        let indexPath = NSIndexPath(row: lastIndex, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)

    }
        
    func playNewRecord(fileURL: URL) {
        
        let url = fileURL
                    
        audioQueuePlayer = AudioQueuePlayer(items: [url])
        audioQueuePlayer!.startPlayback()
    }
    
    @IBAction func playAllAudios(_ sender: UIButton) {
        if audioQueuePlayer?.isPlaying == true{
            audioQueuePlayer?.stopPlayback()
            playAllButton.setTitle("Play all", for: .normal)
        } else {
            
            var urls: [URL] = []
            for item in recordFileManager!.recordings {
                let url = item.fileURL
                //print("url", url)
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

extension RecordingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordFileManager?.recordings.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        cell.audioURL = recordFileManager!.recordings[indexPath.row].fileURL
        cell.fileName.text = cell.audioURL.lastPathComponent
        cell.sequenceNo.text = String(indexPath.row + 1)
        cell.reRecordButton.isEnabled = true
        cell.playButton.setTitle("Play", for: .normal)
        cell.myTableViewController = self
        cell.timeRecorded.text = String(recordFileManager!.recordings[indexPath.row].createdAt.toStringLocalTime(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        
  
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: cell.audioURL)
            let duration = CGFloat(avAudioPlayer!.duration)
            let stringDuration = String(format: "%.2f", Double(duration))
            cell.audioDuration.text = stringDuration + " s"
           
        } catch {}  
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = recordFileManager!.recordings[sourceIndexPath.item]
        recordFileManager!.recordings.remove(at: sourceIndexPath.item)
        recordFileManager!.recordings.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            audioRecorder!.deleteAudioFile(urlsToDelete: (recordFileManager!.recordings[indexPath.row].fileURL))
            recordFileManager?.fetchRecordings()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
  
    @objc func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            audioRecorder!.deleteAudioFile(urlsToDelete: recordFileManager!.recordings[deletionIndexPath[1]].fileURL)
            recordFileManager?.fetchRecordings()
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)

        }
    }
   
}

