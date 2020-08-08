
//
//  SpeechToText.swift
//  MulLe
//
//  Created by Jeeyoung Park on 07.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation
import Speech

class SpeechToTexter: NSObject {

    func speechToText(fileURL: URL, in ) -> String {
        let fileURL =  fileURL
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
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
    
    
    
}
