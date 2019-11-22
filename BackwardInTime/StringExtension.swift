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
        var result = ""
        
        if let year = Calendar.current.dateComponents([.year], from: date).year {
            if year < 1900 {
                result =  String(year)
            }else {
                let formatter = DateFormatter()
                formatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
                result = formatter.string(from: date)
            }
        }
          
        return result
    }
    
    class  func string(of yearsAgo:Double) -> String {
        var resultString = ""
        
        let thousand = 1_000.0
        let million = 1_000_000.0
        let billion = 1_000_000_000.0
        
        if yearsAgo >= billion {
            let result = yearsAgo / billion
            resultString = String("\(round(result * 100) / 100) Billion Years Ago")
        }
        else if yearsAgo >= million {
             let result = yearsAgo / million
           resultString = String("\(round(result * 100) / 100) Million Years Ago")
        }
        else if yearsAgo >= thousand {
             let result = yearsAgo / thousand
            resultString = String("\(round(result * 100) / 100) Thousand Years Ago")
        }
        else {
            resultString = String("\(Int(yearsAgo)) Years Ago")
        }
        
        return resultString
    }

}

