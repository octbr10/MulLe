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
    
    var myTableViewController: ViewController?

    var audioURL: URL!
    var audioPlayer: AudioPlayer!
    var audioRecorder = AudioRecorder()
    
    @IBOutlet var textRecognized: UILabel!
    @IBOutlet var sequenceNo: UILabel!
    @IBOutlet var audioDuration: UILabel!
    @IBOutlet var timeRecorded: UILabel!
    @IBOutlet var reRecordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    @objc func updatePlayButtonText() {
        print("notified...")
        playButton.setTitle("Play", for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playAudio(_ sender: Any) {
        if audioPlayer.isPlaying == false {
            audioPlayer.startPlayback(audio: audioURL)
            playButton.setTitle("Stop", for: .normal)
            reRecordButton.isEnabled = false
        } else {
            audioPlayer.stopPlayback()
            playButton.setTitle("Play", for: .normal)
            reRecordButton.isEnabled = true
        }
    }
    
    @IBAction func deleteRecord(_ sender: Any) {
        myTableViewController?.deleteCell(cell: self)
//        audioRecorder.deleteRecording(urlsToDelete: audioURL)

    }
   
    
    @IBAction func reRecordAudio(_ sender: Any) {
        if audioRecorder.isRecording == false {
            print("Re-Record URL:")
            print(audioURL ?? "test")
            audioRecorder.updateRecording(audio: audioURL)
            reRecordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
            print("recordingStarts")
        } else {
                 reRecordButton.setTitle("Record", for: .normal)
                 audioRecorder.stopRecording()
                 playButton.isEnabled = true
                 print("recordingStopped")
        }
     }
    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            print("CustomTableViewCell")
//            playButton.setTitle("Play", for: .normal)
//            reRecordButton.isEnabled = true
//            audioPlayer.isPlaying = false
//        }
//    }
}
