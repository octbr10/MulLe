//
//  AudioFiles.swift
//  MulLe
//
//  Created by Jeeyoung Park on 04.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation

class RecordFileManager: NSObject {
  
    var recordings = [Recording]()
    
    let folderName: String // user created folder name
    let documentPath: URL // Document Directory
    let folderPath: URL //  Document/folderName
    let fileManager: FileManager
    
    init(in folder: String) {
        
        folderName = folder
        let fileManager = FileManager.default
        documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        folderPath = documentPath.appendingPathComponent(folderName)
        self.fileManager = FileManager.default
        
        super.init()
        
        fetchRecordings()
        
    }
    
//    override init() {
//        super.init()
//        fetchRecordings()
//    }
    
    func fetchRecordings() {
        recordings.removeAll()
        let directoryContents = try! fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, filePath: audio.deletingLastPathComponent().relativePath, fileName: audio.lastPathComponent, createdAt: getCreationDate(for: audio), textRecognized: "non")
            recordings.append(recording)
            print(audio.lastPathComponent)
        }
        recordings.sort(by: { $0.fileName.compare($1.fileName) == .orderedAscending})
        print("====", recordings.count, " audio files are fetched.====")
    }
    
    func getNewAudioURL() -> URL {
        let newAudioURL = folderPath.appendingPathComponent("\(Date().toStringLocalTime(dateFormat: "YYYY-MM-dd HH:mm:ss")).m4a")
        print("currentAudioFileName: ", newAudioURL.lastPathComponent)
        
        return newAudioURL
    }
    
    
}
