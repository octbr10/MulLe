//
//  AudioFiles.swift
//  MulLe
//
//  Created by Jeeyoung Park on 04.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation

class RecordFileManager: NSObject {
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    var recordings = [Recording]()

    
    func fetchRecordings() {
        recordings.removeAll()

        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, filePath: audio.deletingLastPathComponent().relativePath, fileName: audio.lastPathComponent, createdAt: getCreationDate(for: audio), textRecognized: "non")
            recordings.append(recording)
            print(audio.lastPathComponent)
        }
        recordings.sort(by: { $0.fileName.compare($1.fileName) == .orderedAscending})
        print("====", recordings.count, " audio files are fetched.====")
    }
}
