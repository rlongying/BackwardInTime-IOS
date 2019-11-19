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
    let constFactor = pow(M_E, 3)
    
    init(timespanInSeconds timespan: Int) {
        self.timespan = timespan
        FirebaseApp.configure()
        
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
    }
    
    
    func getPassedYears(by percent:Double) -> Double {
        
       
        let expo = 20.3444 * pow(percent, 3) + 3
        
        let passedYears = pow(M_E, expo) - constFactor
        
        return passedYears
    }
}

struct Event:Codable {
    var percentage:Double
    var date:String
    var events:[String]
}
