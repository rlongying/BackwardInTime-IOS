//
//  StringExtension.swift
//  BackwardInTime
//
//  Created by 王梦君 on 2019-11-08.
//  Copyright © 2019 ivan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toHours() -> Int {
        
        // empty input, use default value 0
        if self == "" {
            return 0
        }
        
        // not a valid number
        guard let hours = Int(self) else {
            return -1
        }
        
        if hours > 24 {
            return -1
        }
        
        return hours
    }
    
    func toMinutes() -> Int {
        
        // empty input, use default value 0
        if self == "" {
            return 0
        }
        
        guard let minutes = Int(self) else {
            return -1
        }
        
        if minutes > 60 {
            return -1
        }
        
        return minutes
    }
    
}

class Helpers {
    class func string(of date:Date) -> String {
        
        if let year = Calendar.current.dateComponents([.year], from: date).year {
            if year < 1900 {
                return String(year)
            }else {
                let formatter = DateFormatter()
                formatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
                return formatter.string(from: date)
            }
        }
          
        return " "
    }
    
    class  func string(of yearsAgo:Double) -> String {
        let thousand = 1_000.0
        let million = 1_000_000.0
        let billion = 1_000_000_000.0
        
        if yearsAgo >= billion {
            return String("\(yearsAgo / billion) Billion Years Ago")
        }
        else if yearsAgo >= million {
            return String("\(yearsAgo / million) Million Years Ago")
        }
        else if yearsAgo >= thousand {
            return String("\(yearsAgo / thousand) Thousand Years Ago")
        }
        else {
            return String("\(Int(yearsAgo)) Years Ago")
        }
        
    }
}

