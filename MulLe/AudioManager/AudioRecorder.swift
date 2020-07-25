//AudioRecorder.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import UIKit
import AVFoundation


class AudioRecorder: NSObject {
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
//    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()

    var isRecording     =  false
     
    func startRecording() {
        print("recording starts")
        let recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }

        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toStringLocalTime(dateFormat: "dd-MM-YY'_at_'HH:mm:ss")).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            isRecording = true

        } catch {
            print("Could not start recording")
        }
    }
    
    func updateRecording(audio: URL) {
        print("Re-recording starts")
        let audioFilename = audio
        print("updateRecording URL:")
        print(audioFilename)
        deleteRecording(urlsToDelete: audioFilename)

        let recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }



        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            isRecording = true

        } catch {
            print("Could not start Re-recording")
        }
    }
    
    
    func stopRecording() {
        print("recording Stopped")
        audioRecorder.stop()
        isRecording = false
        fetchRecordings()
    }
    
    func fetchRecordings() {
        print("fetch is working")
        recordings.removeAll()

        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }

        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})

    }
    
    func deleteRecordings(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecordings()
    }
    
    func deleteRecording(urlsToDelete: URL) {
        
           do {
               try FileManager.default.removeItem(at: urlsToDelete)
            } catch {
                print("File could not be deleted!")
            }
        fetchRecordings()
    }
    
    
}
