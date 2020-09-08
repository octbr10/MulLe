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
    var audioRecorder: AudioRecorder?
    var audioPlayer: AudioPlayer?

    var titleText: String?
    var userLanguage: String?
      
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var recordButton: UIButton!
    //@IBOutlet weak var playAllButton: UIButton!
    @IBOutlet weak var changeLanguage: UIButton!

    
    let cellIdentifier: String = "cell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = titleText
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordFileManager = RecordFileManager(in: titleText ?? "Default Folder")
        audioRecorder = AudioRecorder()
        audioPlayer = AudioPlayer()
        
          
        let userDefaultLanguage = UserDefaults.standard.object(forKey: "speechLanguage") as? String
        print("userDefaultLanguage: ", userDefaultLanguage ?? "de-DE")
        let lang = Locale.init(identifier: userDefaultLanguage ?? "de-DE")
        let enLocale = Locale.init(identifier: "en")
        userLanguage =  enLocale.localizedString(forIdentifier: lang.identifier)
        print("userLanguage RecordingViewController viewDidLoad: ", userLanguage!)
        changeLanguage.setTitle(userLanguage, for: .normal)

        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(manageNotification), name: NSNotification.Name(rawValue: "audioPlayerDidFinishPlaying"), object: nil)


    }
    
    @objc func manageNotification(notification: NSNotification) {
        guard let audioURL = notification.userInfo?["audioURL"] as? URL else {return}
        guard let playType = (notification.userInfo? ["playbackType"]) as? String else {return}
        let index = recordFileManager?.getIndexForURL(audioURL: audioURL) ?? 0
        
        switch PlaybackType(rawValue: playType) {
        case .NewRecord:
                recordFileManager?.fetchRecordings()
                self.tableView.reloadRows(at: [IndexPath.init(row: ((recordFileManager?.recordings.count)! - 1), section: 0)], with: .automatic)
        case .ReRecord:
            recordFileManager?.fetchRecordings()
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.none)

        case .Normal:
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.none)
            if index + 1 != (recordFileManager?.recordings.count)! {
                audioPlayer?.startPlayback(audio: (recordFileManager?.recordings[index + 1].fileURL)!)
                tableView.selectRow(at: IndexPath(row: index + 1, section: 0), animated: true, scrollPosition: .bottom)
            }
        default:
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.none)
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        if self.audioPlayer?.isPlaying == true {
            self.audioPlayer?.stopPlayback()
        }
    }
    
    @objc func QPlayerItems(notification: NSNotification) {
        if let avPlayerItems = notification.userInfo? ["QPlayerItems"] as? [AVPlayerItem] {
           
            for item in avPlayerItems {
                let url: URL? = (item.asset as? AVURLAsset)?.url
 
                print("playerItems URL: ", url!)
            }
         
        }
    }
   
    @IBAction func touchDownRecord(_ sender: UIButton) {
        if audioRecorder?.isRecording == true {
            recordButton?.isSelected = false
            recordButton?.tintColor = .darkGray
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
            let indexPath = IndexPath(row: lastIndex, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        } else {
            recordButton?.isSelected = true
            recordButton?.tintColor = .systemRed
            audioPlayer?.stopPlayback()
            let newAudioURL = recordFileManager!.getNewAudioURL()
            audioRecorder?.startRecording(at: newAudioURL)
        }
        
    }
    
//    @IBAction func touchUpRecordStop(_ sender: UIButton) {
//
//        audioRecorder?.stopRecording()
//        recordFileManager?.fetchRecordings()
//
//        let lastIndex = recordFileManager!.recordings.endIndex - 1
//        let url = recordFileManager!.recordings[lastIndex].fileURL
//        if audioRecorder?.speechToText(fileURL: url) != "no text recognized" {
//            print(audioRecorder?.speechToText(fileURL: url) ?? "no text recognized") //return 값이 "no text recognized" 임
//        }
//
//        playNewRecord(fileURL: url)
//        self.tableView.reloadData()
//
//        // scroll to the last row
//        let indexPath = IndexPath(row: lastIndex, section: 0)
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
//
//    }
        
    func playNewRecord(fileURL: URL) {
        let url = fileURL
        audioPlayer?.newRecordPlayback(audio: url)
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
        
        cell.audioPlayer = audioPlayer
        cell.audioURL = recordFileManager!.recordings[indexPath.row].fileURL
       
        let s = cell.audioURL.lastPathComponent
        let start = s.index(s.startIndex, offsetBy: 20)
        let end = s.index(s.endIndex, offsetBy: -4)
        if s.count == 23 {
            cell.textTitle.text = cell.audioURL.lastPathComponent
        } else {cell.textTitle.text = String(s[start..<end])}
        
           
            cell.reRecordButton.isEnabled = true
         
        
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
    
    // cell select then playback
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        
        if  audioPlayer?.isPlaying == true && audioPlayer?.currentAudio == cell.audioURL {
            tableView.deselectRow(at: indexPath, animated: true)
            audioPlayer?.stopPlayback()
       
        } else {
        
            let labelText = cell.textTitle.text
            UIPasteboard.general.string = labelText
            print("selected cell index path:", indexPath, "Copyed LabelText:", labelText ?? "no Label Text")
            print("cell.isSelected", cell.isSelected)
           
            audioPlayer?.startPlayback(audio: cell.audioURL)
        
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        cell.setSelected(false, animated: true)
        print("cell.isSelected", cell.isSelected)
        //cell.textTitle.text = "deselected"
        

    }
    
}

