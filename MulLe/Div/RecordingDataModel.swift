//RecordingDataModel.swift

//Created by BLCKBIRDS on 28.10.19.
//Visit www.BLCKBIRDS.com for more.

import Foundation

struct Recording {
    let fileURL: URL // File path including document(directory) path
    let filePath: String // 마지막 제외
    var fileName: String
    let createdAt: Date // file creation or audioUpdated date.
    var textRecognized: String
}
