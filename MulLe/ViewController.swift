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
    
    @IBOutlet weak var transcriptionTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.reloadData()
        
        audioRecorder = AudioRecorder()
        audioPlayer = AudioPlayer()

        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayAllButton), name: NSNotification.Name(rawValue: "qPlayerDidFinishPlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetButtons), name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil)
        
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
    }
    
    @objc func resetButtons() {
        tableView.reloadData()
    }
    
    
//    @IBAction func touchUpRecordButton(_ sender: UIButton) {
//        if audioRecorder?.isRecording == false {
//            audioRecorder!.startRecording()
//            recordButton.setTitle("Stop", for: .normal)
//            self.tableView.reloadData()
//            //self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
//        } else {
//            recordButton.setTitle("Record", for: .normal)
//            audioRecorder!.stopRecording()
//            self.tableView.reloadData()
//            playNewRecord()
//        }
//    }
    
    @IBAction func touchDownRecord(_ sender: UIButton) {
                audioRecorder?.startRecording()
    }
    
    @IBAction func touchUpRecordStop(_ sender: UIButton) {
                    audioRecorder?.stopRecording()
                    self.tableView.reloadData()
                    playNewRecord()
    }
    
        
    func playNewRecord() {
        let lastIndex = audioRecorder!.recordings.endIndex - 1
        let url = audioRecorder!.recordings[lastIndex].fileURL
        audioQueuePlayer = AudioQueuePlayer(items: [url])
        audioQueuePlayer!.startPlayback()
        
        var textRecognized: String
        textRecognized = speechToText(fileURL: url)
        print(textRecognized) // 여기서는 textRecognized가 널 임. speedchToText 내에서 처리해야함.
    }
    
//    func requestSpeechAuth(path:URL) {
//        let path = path
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
//                if self.audioRecorder!.recordings.count != 0 {
//
////                  self.transcriptionTextField.text = self.speechToText(fileURL: path)
//
//                    let recognizer = SFSpeechRecognizer()
//                    let request = SFSpeechURLRecognitionRequest(url: path)
//                    recognizer?.recognitionTask(with: request)
//                    { (result, error) in
//                        if let error = error {
//                            print("There was an error: \(error)")
//                        } else {
//                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
//                            if (result?.isFinal)! {
//                                print("Success")
//                            }
//                        }
//                    }
//
//                }
//            }
//        }
//    }
    
    func speechToText(fileURL: URL) -> String {
        
        var textResult: String = "no Text Recoginized"
   
        let fileURL =  fileURL
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        request.shouldReportPartialResults = true

        if (recognizer?.isAvailable)! {

            recognizer?.recognitionTask(with: request) { result, error in
                guard error == nil else { print("Error: \(error!)"); return }
                guard let result = result else { print("No result!"); return }
                textResult = result.bestTranscription.formattedString
                print("SpeechToText Print: ", result.bestTranscription.formattedString)
            }
        } else {
            print("Device doesn't support speech recognition")
        }
            return textResult
    }
    
    
    @IBAction func playAllAudios(_ sender: UIButton) {
        if audioQueuePlayer?.isPlaying == true{
            audioQueuePlayer?.stopPlayback()
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
        
        cell.sequenceNo.text = String(indexPath.row + 1)
//        cell.sequenceNo.text = String(audioRecorder!.recordings.count - indexPath.row)
//        cell.textRecognized.text = speechToText(fileURL: audioRecorder!.recordings[indexPath.row].fileURL)
        cell.audioURL = audioRecorder!.recordings[indexPath.row].fileURL
        cell.reRecordButton.isEnabled = true
        cell.playButton.setTitle("Play", for: .normal)
        cell.myTableViewController = self
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

