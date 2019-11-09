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
