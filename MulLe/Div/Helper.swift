//Helper.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

func appendToFileName(fileURL: URL, newFileName: String) {

    var fileURL = fileURL
    let oldFileName = fileURL.lastPathComponent.components(separatedBy: ".")[0]
    let oldDate = oldFileName.components(separatedBy: "_")[0]
    let newName = oldDate + "_" + newFileName + ".m4a"
    var rv = URLResourceValues()
    
    rv.name = newName
    try? fileURL.setResourceValues(rv)
 
}

func createFolder(folderName: String){
    let directoryName = folderName
    
    let fileManager = FileManager.default
    let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryURL = documentURL.appendingPathComponent(directoryName)
    
    do {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: nil)
        print("directoryName: ", directoryName, " folder has been created.")
    } catch let e {
        print(e.localizedDescription)
    }
    
}

func fetchFolders() -> [String] {
    let fileManager = FileManager.default
    let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let myDocumentsDirectory = dirPaths[0]

    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(at: myDocumentsDirectory, includingPropertiesForKeys: nil, options: [])
        let subdirs = directoryContents.filter{ $0.hasDirectoryPath }
        var subDirNamesStr = subdirs.map{ $0.lastPathComponent }
        subDirNamesStr.sort(by: { $0.compare($1) == .orderedAscending})

        
        print("subDirNamesStr :", subDirNamesStr)
        return subDirNamesStr
        // now do whatever with the onlyFileNamesStr & subdirNamesStr
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    return []
}

func deleteFolder(folderName: String) {
    
    let fileManager = FileManager.default
    let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryURL = documentURL.appendingPathComponent(folderName)
    
    do {
        try FileManager.default.removeItem(at: directoryURL)
        print("directoryURL: ", directoryURL)
        print(folderName, "has been deleted")
    } catch {
        print("File could not be deleted!")
        
    }
}




//func fetchFolders() {
//    let fileManager = FileManager.default
//    let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//    let myDocumentsDirectory = dirPaths[0]
//
//    do {
//        let directoryContents = try FileManager.default.contentsOfDirectory(at: myDocumentsDirectory, includingPropertiesForKeys: nil, options: [])
//
//        let onlyFileNames = directoryContents.filter{ !$0.hasDirectoryPath }
//        let onlyFileNamesStr = onlyFileNames.map { $0.lastPathComponent }
//        print("onlyFileNamesStr", onlyFileNamesStr)
//
//        let subdirs = directoryContents.filter{ $0.hasDirectoryPath }
//        let folderArray = subdirs.map{ $0.lastPathComponent }
//        print("subdirNamesStr", subdirNamesStr)
//
//        // now do whatever with the onlyFileNamesStr & subdirNamesStr
//    } catch let error as NSError {
//        print(error.localizedDescription)
//    }
//}


//do {
//    let files = try FileManager.default.contentsOfDirectory(atPath: "/Users/username/Documents/Photos")
//
//    print(files)
//} catch {
//    print(error)
//}
