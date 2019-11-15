//
//  EventModel.swift
//  BackwardInTime
//
//  Created by 王梦君 on 2019-11-14.
//  Copyright © 2019 ivan. All rights reserved.
//

import Foundation
import Firebase

class Event {
    init() {
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
    }
}
