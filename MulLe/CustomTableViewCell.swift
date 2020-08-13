//
//  CustomTableViewCell.swift
//  MulLe
//
//  Created by Jeeyoung Park on 23.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//
import UIKit
import AVFoundation


// Mark: - CustomTableViewCell

class CustomTableViewCell: UITableViewCell{
    
    var myTableViewController: RecordingViewController?
    
    weak var delegate: CustomCellDelegate?

    var audioURL: URL!
    var audioRecorder = AudioRecorder()
    var audioQueuePlayer: AudioQueuePlayer?
    var audioPlayer: AudioPlayer!
    var recordFileManager: RecordFileManager?
    
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var audioDuration: UILabel!
    @IBOutlet var timeRecorded: UILabel!
    @IBOutlet var reRecordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var deleteButton:UIButton!
    
    
    @objc func updatePlayButtonText() {
        print("notified...")
        playButton.setTitle("Play", for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    @IBAction func playAudio(_ sender: Any) {
        
        delegate?.buttonTapped(cell: self)

        self.setSelected(true, animated: true)
        //self.isSelected = !self.isSelected
        
        if  audioPlayer?.isPlaying == true {
            audioPlayer?.stopPlayback()
            playButton.setTitle("Play", for: .normal)
        } else {
            //audioPlayer = AudioPlayer()
            audioPlayer?.startPlayback(audio: audioURL)
            playButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func deleteRecord(_ sender: Any) {
        myTableViewController?.deleteCell(cell: self)
        recordFileManager?.fetchRecordings()
//        audioRecorder.deleteRecording(urlsToDelete: audioURL)

    }
    

   
    
//    @IBAction func reRecordAudio(_ sender: Any) {
//        if audioRecorder.isRecording == false {
//            print("Re-Record URL:")
//            print(audioURL ?? "test")
//            audioRecorder.updateRecording(audio: audioURL)
//            reRecordButton.setTitle("Stop", for: .normal)
//            playButton.isEnabled = false
//            print("recordingStarts")
//        } else {
//                 reRecordButton.setTitle("Record", for: .normal)
//                 audioRecorder.stopRecording()
//                 playButton.isEnabled = true
//                 print("recordingStopped")
//        }
//     }
    
    @IBAction func copyTextTitle() {
        UIPasteboard.general.string = textTitle.text
        
    }
    
    @IBAction func touchDownReRecord(_ sender: Any) {
        if audioRecorder.isRecording == false {
            audioRecorder.updateRecording(audio: audioURL)
            
        }
    }
    
    @IBAction func touchUpReRecordStop(_ sender: Any) {
        audioRecorder.stopRecording()
        recordFileManager?.fetchRecordings()
        
        if audioRecorder.speechToText(fileURL: audioURL) != "no text recognized" {
            print(audioRecorder.speechToText(fileURL: audioURL)) //return 값이 "no text recognized" 임
        }
        
        let url = audioURL!
        audioQueuePlayer = AudioQueuePlayer(items: [url])
        audioQueuePlayer?.startPlayback()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
       
        self.playButton.isHidden = editing
        self.deleteButton.isHidden = editing
        self.reRecordButton.isHidden = editing
        
        if isEditing == true {
            var frame = self.audioDuration.frame
             frame.origin.x = 15;
             self.audioDuration.frame = frame;
        } else {
            var frame = self.audioDuration.frame
             frame.origin.x = 50;
             self.audioDuration.frame = frame;
        }
    }
    
  
    
}

protocol CustomCellDelegate: AnyObject {
    func buttonTapped(cell: CustomTableViewCell)
}
