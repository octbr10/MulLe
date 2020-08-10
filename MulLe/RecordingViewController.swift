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
    var recordFileManager: RecordFileManager?
    var audioQueuePlayer = AudioQueuePlayer(items: [FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]])
    var audioRecorder: AudioRecorder?
    var audioPlayer: AudioPlayer?
    //var speechLanguage: SpeechLanguage?

    var titleText: String?
    var userLanguage: String?
      
    @IBOutlet weak var tableView:UITableView!
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playAllButton: UIButton!
    @IBOutlet weak var changeLanguage: UIButton!

    
    let cellIdentifier: String = "cell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = titleText
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.reloadData()
        
        recordFileManager = RecordFileManager(in: titleText ?? "Default Folder")
        audioRecorder = AudioRecorder()
        //speechLanguage = SpeechLanguage()
          
        let userDefaultLanguage = UserDefaults.standard.object(forKey: "speechLanguage") as? String
        print("userDefaultLanguage: ", userDefaultLanguage ?? "de-DE")
        let lang = Locale.init(identifier: userDefaultLanguage ?? "de-DE")
        let enLocale = Locale.init(identifier: "en")
        userLanguage =  enLocale.localizedString(forIdentifier: lang.identifier)
        print("userLanguage RecordingViewController viewDidLoad: ", userLanguage!)
        changeLanguage.setTitle(userLanguage, for: .normal)
        
//        print("speechLanguage:", speechLanguage!, "at LocaleViewController viewDidLoad")

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
        recordFileManager?.fetchRecordings()
        self.tableView.reloadData()
    }
    
    @objc func resetButtons(notification: NSNotification) {
        
        if let audioURL = notification.userInfo?["audioURL"] as? URL {
            print("notification audioURL: ", audioURL)
            
//            recordFileManager?.fetchRecordings()
//            self.tableView.reloadData()

            let index = recordFileManager?.getIndexForURL(audioURL: audioURL) ?? 0
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.none)
//            }   else {
//                recordFileManager?.fetchRecordings()
//                self.tableView.reloadData()
//            }
            
            
        }

           //audioRecorder?.fetchRecordings()
           //self.tableView.reloadData()

    }
   
    @IBAction func touchDownRecord(_ sender: UIButton) {

        let newAudioURL = recordFileManager!.getNewAudioURL()
        audioRecorder?.startRecording(at: newAudioURL)
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

        self.tableView.reloadData()

        // scroll to the last row
        let indexPath = NSIndexPath(row: lastIndex, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        //audioPlayer?.startPlayback(audio: url)
    }
        
    func playNewRecord(fileURL: URL) {
        
        let url = fileURL
//        audioPlayer = AudioPlayer()
//        audioPlayer?.startPlayback(audio: url)
        audioQueuePlayer = AudioQueuePlayer(items: [url])
        audioQueuePlayer.startPlayback()
    }
    
    @IBAction func playAllAudios(_ sender: UIButton) {
        if  audioQueuePlayer.isPlaying == true{
            audioQueuePlayer.stopPlayback()
            playAllButton.setTitle("Play all", for: .normal)
        } else {
            
            var urls: [URL] = []
            for item in recordFileManager!.recordings {
                let url = item.fileURL
                //print("url", url)
                urls.append(url)
                }
            playAllButton.setTitle("Stop", for: .normal)
            audioQueuePlayer = AudioQueuePlayer(items: urls)
            audioQueuePlayer.startPlayback()
        }
    
  }
    
    // MARK - IBACTION
    @IBAction func editRecordingList(_ sender: UIBarItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        print(self.tableView.isEditing)
        sender.title = (self.tableView.isEditing) ? "Done": "Edit"
          
        
    }
    
   // when LocaleViewController is dismissed...
    @IBAction func modalDismissed(segue: UIStoryboardSegue) {
        
        let userDefaultLanguage = UserDefaults.standard.object(forKey: "speechLanguage") as? String
        let lang = Locale.init(identifier: userDefaultLanguage ?? "de-DE")
        let enLocale = Locale.init(identifier: "en")
        userLanguage =  enLocale.localizedString(forIdentifier: lang.identifier)
        changeLanguage.setTitle(userLanguage, for: .normal)
       
        
      // You can use segue.source to retrieve the VC
      // being dismissed to collect any data which needs
      // to be processed
    }

    
    
}

// Mark: - UITableViewCell 정의

extension RecordingViewController: UITableViewDataSource, UITableViewDelegate, CustomCellDelegate {
    
    func buttonTapped(cell: CustomTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        print("Play button clicked indexPath!.row", indexPath!.row)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordFileManager?.recordings.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell

        cell.delegate = self
 
        cell.audioURL = recordFileManager!.recordings[indexPath.row].fileURL
       
        let s = cell.audioURL.lastPathComponent
        let start = s.index(s.startIndex, offsetBy: 20)
        let end = s.index(s.endIndex, offsetBy: -4)
        if s.count == 23 {
            cell.textTitle.text = cell.audioURL.lastPathComponent
        } else {cell.textTitle.text = String(s[start..<end])}
        
        //cell.fileName.text = cell.audioURL.lastPathComponent
           
            cell.reRecordButton.isEnabled = true
            cell.playButton.setTitle("Play", for: .normal)
         
        
        cell.myTableViewController = self
        cell.timeRecorded.text = String(recordFileManager!.recordings[indexPath.row].createdAt.toStringLocalTime(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        
  
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: cell.audioURL)
            let duration = CGFloat(avAudioPlayer!.duration)
            let stringDuration = String(format: "%.1f", Double(duration))
            cell.audioDuration.text = stringDuration + " s"
           
        } catch {}  
        
        return cell
    }
    
   
    // delete by swipe
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
    
//   func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//       let movedObjTemp = recordFileManager!.recordings[sourceIndexPath.item]
//       print("sourceIndexPath.item: ", sourceIndexPath.item)
//       recordFileManager!.recordings.remove(at: sourceIndexPath.item)
//       recordFileManager!.recordings.insert(movedObjTemp, at: destinationIndexPath.item)
//   }
    
}

