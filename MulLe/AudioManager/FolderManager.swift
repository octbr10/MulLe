//
//  FolderManager.swift
//  MulLe
//
//  Created by Jeeyoung Park on 05.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation

class FolderManager: NSObject {
    
    var folders = [Folder]()
    
    override init() {
        super.init()
        fetchFolders()
    }
    
    func fetchFolders(){
        folders.removeAll()
        
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: dirPaths, includingPropertiesForKeys: nil, options: [])
            let subdirs = directoryContents.filter{ $0.hasDirectoryPath }
            var subDirNamesStr = subdirs.map{ $0.lastPathComponent }
            subDirNamesStr.sort(by: { $0.compare($1) == .orderedAscending})
            
            for folder in subDirNamesStr {
                let folderPath = dirPaths.appendingPathComponent(folder)
                let directoryContents = try! fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
                let count = directoryContents.count
                
                let folder = Folder(folderURL: folderPath, folderName: folder, fileCount: String(count), createdAt: getCreationDate(for: folderPath))
                folders.append(folder)
                //print("fileCounts:", fileCounts)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    
    
//    func countFiles(in folder: [String]) -> [String] {
//
//        var fileCounts: [String] = []
//        let fileManager = FileManager.default
//
//
//        for folder in fetchFolders() {
//            let folderPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(folder)
//            let directoryContents = try! fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
//            let count = directoryContents.count
//            fileCounts.append(String(count))
//            //print("fileCounts:", fileCounts)
//        }
//
//        return fileCounts
//    }
    
    
    

}

