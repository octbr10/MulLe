//
//  APIClient.swift
//  MulLe
//
//  Created by Jeeyoung Park on 16.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//
import Foundation
import UIKit

class APIClient {
    
    func getData() ->[Item] {
        var array: [Item] = [Item]()
        
        let item1 = Item(audioIndex: 2, audioTitle: "Guten Morgen")
        let item2 = Item(audioIndex: 1, audioTitle: "Guten Tag")

        array.append(item1)
        array.append(item2)
        
        return array
        
    }
}
