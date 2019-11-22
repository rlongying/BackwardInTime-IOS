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
    
    // a const used in formula
    let E_POW_3 = pow(M_E, 3)
    let calendar = Calendar.current
    let DAYS_A_YEAR = 365.212499
    let CONSTANT_FACTOR = 20.3444
    
    init() {

        // configure the app only if not had been configured,
        // other it throws exception : "Default app has already been configured"
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // test cases
//
//        print("passed: \(getPassedYears(by: 0.8538))")
//        var dateComponents = DateComponents(calendar: calendar, year: 1918, month: 1, day: 1)
//        var date = calendar.date(from: dateComponents)
//        print("percentage of date: \(getPercentage(of: date!))")
//        print("percentage of years ago: \(getPercentage(of: 1012))")
//
//        print("date to string: \(Helpers.string(of: date!))")
//
//        dateComponents = DateComponents(calendar: calendar, year: 1899, month: 1, day: 1)
//        date = calendar.date(from: dateComponents)
//        print("date to string < 1900: \(Helpers.string(of: date!))")
//        print("yearsAgo to string: \(Helpers.string(of: 13_760_000_000.0))")
//        print("yearsAgo to string: \(Helpers.string(of: 680_000_000.0))")
//        print("yearsAgo to string: \(Helpers.string(of: 25_000.0))")
//        print("yearsAgo to string: \(Helpers.string(of: 300.0))")
    }
    
    // MARK: - Firebase Operations
    func getEvents(completion: @escaping ([Event], Error?) -> Void) {
        
        var events:[Event] = []
        
        let db = Firestore.firestore()
        db.collection("events").getDocuments {
            [weak self](querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(events, err)
                return
            }
            
            for doc in querySnapshot!.documents {
                
                let data = doc.data()
                print("\(doc.documentID) => \(doc.data())")
                print("date: \(data["date"] ?? "no date")")
                
                // get date and conver to date type
                let timestamp:Timestamp = data["date"] as! Timestamp
                let date:Date = timestamp.dateValue()
                
                print("date value: \(date)")
                
                // get events
                let titles = data["events"] as? [String] ?? [""]
                
                // get years
                let years = data["years"] as? Double ?? -1
                print("years: \(years)")
                
                for e in titles {
                    print("event: \(e)")
                }
                var event = Event(date: date, titles: titles, yearsAgo: years)
                
                guard let strongSelf = self else{
                    return
                }
                
                if event.yearsAgo == -1 {
                    // use date
                    event.percentage = strongSelf.getPercentage(of: event.date)
                }else {
                    // use years
                    event.percentage = strongSelf.getPercentage(of: event.yearsAgo)
                }
                
                events.append(event)
            }
            completion(events, nil)
        }
    }
    
    
    // MARK: - Helper functions to calcuate years and percentage
    func getPassedYears(by percent:Double) -> Double {
        
        
        let expo = CONSTANT_FACTOR * pow(percent, 3) + 3
        
        let passedYears = exp(expo) - E_POW_3
        
        return passedYears
    }
    
    func getYearsBy(percentage:Double) -> Date {
        let passedYears = getPassedYears(by: percentage)
        
        let now = Date()
        
        let dateYearsAgo = calendar.date(byAdding: .year, value: 0 - Int(passedYears), to: now)
        
        return dateYearsAgo!
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

struct Event{
    var percentage:Double = 0
    var date:Date
    var titles:[String]
    var yearsAgo:Double
}
