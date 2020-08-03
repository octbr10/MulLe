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
