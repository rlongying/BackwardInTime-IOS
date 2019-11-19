//
//  EventModel.swift
//  BackwardInTime
//
//  Created by 王梦君 on 2019-11-14.
//  Copyright © 2019 ivan. All rights reserved.
//

import Foundation
import Firebase

class EventModal {
    // a period of time in seconds
    var timespan: Int = 0
    
    // a const used in formula
    let E_POW_3 = pow(M_E, 3)
    let calendar = Calendar.current
    let DAYS_A_YEAR = 365.212499
    let CONSTANT_FACTOR = 20.3444
    
    init(timespanInSeconds timespan: Int) {
        self.timespan = timespan
       
        // configure the app only if not had been configured,
        // other it throws exception : "Default app has already been configured"
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        let db = Firestore.firestore()
        
        
        db.collection("events").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                for doc in querySnapshot!.documents {
                    let data = doc.data()
                    print("\(doc.documentID) => \(doc.data())")
                    print("date: \(data["date"] ?? "no date")")
                    
                    let events = data["events"] as? [String] ?? [""]
                    
                    for e in events {
                        print("event: \(e)")
                    }
                    
                }
            }
        }
        
        print("passed: \(getPassedYears(by: 0.8538))")
        let dateComponents = DateComponents(calendar: calendar, year: 1918, month: 1, day: 1)
        let date = calendar.date(from: dateComponents)
        print("percentage of date: \(getPercentage(of: date!))")
        print("percentage of years ago: \(getPercentage(of: 1012))")
    }
    
    // MARK: - Helper functions to calcuate years and percentage
    func getPassedYears(by percent:Double) -> Double {
        
       
        let expo = CONSTANT_FACTOR * pow(percent, 3) + 3
        
        let passedYears = exp(expo) - E_POW_3
        
        return passedYears
    }
    
    func getPassedYears(by date:Date) -> Double {
        let now = Date()
        
        let timePeriodComponents = calendar.dateComponents([.day], from: date, to: now)
        
        let daysPassed = Double(timePeriodComponents.day!)
         print("inside dayPassed passed: \(daysPassed)")
        
        return daysPassed / DAYS_A_YEAR
    }
    
    func getPercentage(of date:Date) -> Double {
        
        let yearsPassed = getPassedYears(by: date)
        
        print("inside years passed: \(yearsPassed)")
        
        return calcPercentage(yearsPassed)
    }
    
    func getPercentage(of yearsPassed:Double) -> Double {
        
        return calcPercentage(yearsPassed)
    }
    
    private func calcPercentage(_ yearsPassed:Double) -> Double {
        return pow((ln(yearsPassed + E_POW_3 ) - 3) / CONSTANT_FACTOR, 1 / 3)
    }
    
    private func ln(_ value: Double) -> Double {
        return log(value) / log(M_E)
    }
}

// MARK: - Event Struct Definition

struct Event:Codable {
    var percentage:Double
    var date:String
    var events:[String]
}
