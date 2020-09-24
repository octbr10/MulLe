//AudioRecorder.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

//import UIKit
import AVFoundation
import Speech

class AudioRecorder: NSObject {
     
    override init() {
        super.init()
    }
    
    var audioRecorder: AVAudioRecorder!
    var currentAudioFileName: URL?
    var isRecording = false
     
    func startRecording(at newAudioURL:URL) {
 
        let newAudioURL = newAudioURL
        
        print("recording starts")
        let recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }

//        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        currentAudioFileName = documentPath.appendingPathComponent("\(Date().toStringLocalTime(dateFormat: "YYYY-MM-dd HH:mm:ss")).m4a")
//        print("currentAudioFileName: ", currentAudioFileName?.lastPathComponent ?? "noLastPathComponent")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey:16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: newAudioURL, settings: settings)
            audioRecorder.record()
            isRecording = true

        } catch {
            print("Could not start recording")
        }
    }
    
              
    func stopRecording() {
        if isRecording == true {
            print("recording Stopped")
            audioRecorder.stop()
            isRecording = false
        }
    }
    
    func updateRecording(audio: URL) {
        let audioFilename = audio
        print("updateRecording URL:", audioFilename)
        deleteAudioFile(urlsToDelete: audioFilename)

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
    
    func speechToText(fileURL: URL) -> String {
        let fileURL =  fileURL
        let userDefaultLanguage = UserDefaults.standard.object(forKey: "speechLanguage") as? String ?? "ko-KR"
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: userDefaultLanguage))
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        request.shouldReportPartialResults = false
        
        var textFromSpeech: String = "no text recognized"
        
        if (recognizer?.isAvailable)! {

            recognizer?.recognitionTask(with: request) { result, error in
                guard error == nil else { print("Error: \(error!)"); return }
                guard let result = result, result.isFinal else { print("No result!"); return }
                textFromSpeech = result.bestTranscription.formattedString
                print("textResult: ", textFromSpeech)
                
                appendToFileName(fileURL: fileURL, newFileName: textFromSpeech)
           
            }
        } else {
            print("Device doesn't support speech recognition")

        }
        return textFromSpeech
    }

    
    func deleteAudioFile(urlsToDelete: URL) {
           do {
               try FileManager.default.removeItem(at: urlsToDelete)
            } catch {
                print("File could not be deleted!")
            }
    }

}
