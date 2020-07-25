//
//  Extensions.swift
//  MulLe
//
//  Created by Jeeyoung Park on 22.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation

extension Date
{
    func toStringLocalTime( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringGMTTime( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier:"GMT")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
