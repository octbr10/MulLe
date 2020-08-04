//
//  FolderDataModel.swift
//  MulLe
//
//  Created by Jeeyoung Park on 04.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation

struct Folder {
    let folderURL: URL
    let folderName: String
    let createdAt: Date // 정렬시 필요
}
