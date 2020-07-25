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

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AudioRecorder?
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var recordButton: UIButton!
    
    let cellIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        audioRecorder = AudioRecorder()
    }
    
    @IBAction func touchUpRecordButton(_ sender: UIButton) {
        if audioRecorder?.isRecording == false {
            audioRecorder?.startRecording()
            recordButton.setTitle("Stop", for: .normal)
            self.tableView.reloadData()
            //self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
        } else {
            recordButton.setTitle("Record", for: .normal)
            audioRecorder?.stopRecording()
            self.tableView.reloadData()
//            self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
        }
    }
    
    @IBAction func editList(_ sender: UIBarItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done": "Edit"
        
    }
    
}


// Mark: - UITableViewCell 정의

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioRecorder?.recordings.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        cell.myTableViewController = self
   
        cell.audioURL = audioRecorder?.recordings[indexPath.row].fileURL
        
        cell.sequenceNo.text = String(audioRecorder!.recordings.count - indexPath.row)
        
        cell.timeRecorded.text = String(audioRecorder?.recordings[indexPath.row].createdAt.toStringLocalTime(dateFormat: "YY-MM-dd HH:mm:ss") ?? "non")
        
  
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: cell.audioURL)
            let duration = CGFloat(audioPlayer!.duration)
            let stringDuration = String(format: "%.2f", Double(duration))
            cell.audioDuration.text = stringDuration + " s"
           
        } catch {}  
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = audioRecorder?.recordings[sourceIndexPath.item]
        audioRecorder?.recordings.remove(at: sourceIndexPath.item)
        audioRecorder?.recordings.insert(movedObjTemp!, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            audioRecorder?.recordings.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            audioRecorder?.deleteRecording(urlsToDelete: (audioRecorder?.recordings[indexPath.row].fileURL)!)
            
        }
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            audioRecorder?.recordings.remove(at: deletionIndexPath.item)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
            audioRecorder?.deleteRecording(urlsToDelete: (audioRecorder?.recordings[deletionIndexPath.row].fileURL)!)
        }
    }
   
}

