//
//  ViewController.swift
//  BackwardInTime
//
//  Created by 王梦君 on 2019-11-08.
//  Copyright © 2019 ivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Timer UIs
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minsTextField: UITextField!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minsLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Progress UIs
    
    @IBOutlet weak var progressBar: UIProgressView!
    //    progressBar.transform = progressView.transform.scaledBy(x: 1, y: 9)
    
    
    
    @IBOutlet weak var twentyLabel: UILabel!
    @IBOutlet weak var fourtyLabel: UILabel!
    @IBOutlet weak var sixtyLabel: UILabel!
    @IBOutlet weak var eightyLabel: UILabel!
    @IBOutlet weak var hundredLabel: UILabel!
    
    //MARK: - History Events UIs
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    
    
    //MARK: - Custom Properties
    var timer:Timer = Timer()
    var hours = -1
    var minutes = -1
    var seconds = 0
    var eventModel:EventModal!
    var hoursValue = 0
    var minutesValue = 0
    var events:[Event]!
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        eventModel = EventModal()
        eventModel.getEvents {
            [weak self](eventArray, error) in
            if (error != nil) {
                print("view did load event error: \(String(describing: error))")
            }
          
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.events = eventArray
                      if (strongSelf.events.count) > 0 {
                          strongSelf.events.sort { (e1, e2) -> Bool in
                              return e1.percentage > e2.percentage
                          }
                      }
          
        }
        
        // update labels
        updateLabels()
    }
    
    
    //MARK: - UI Events
    @IBAction func startTimerTapped(_ sender: UIButton) {
        
        resetTimer()
        
        if hours == -1 || minutes == -1 {
            // input error
            errorLabel.text = "Wrong format of hours or minutes"
        }
        else if hours == 0 && minutes == 0{
            // set textfield to actual value, do this because if default
            // value is used, the textfield would be empty, but we want to show 0
            hourTextField.text = String(hours)
            minsTextField.text = String(minutes)
            errorLabel.text = "Hours and minutes cannot be both 0"
        }else {
            
            hourLabel.text = hours < 10 ? String("0\(hours)"):String(hours)
            minsLabel.text = minutes < 10 ? String("0\(minutes)"):String(minutes)
            secondsLabel.text = "00"
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
                [weak self] (_) in
                
                guard let strongSelf = self else {
                               return
                           }
                strongSelf.updateTimer()
                
                DispatchQueue.main.async{
                    strongSelf.updateProgress()
                }
                
            })
            
        }
        
    }
    
    func updateLabels() {
        // 20% percent label
        let twentyPercentDate = eventModel.getYearsBy(percentage: 0.2)
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM yyyy")
        twentyLabel.text = formatter.string(from: twentyPercentDate)
        
        // 40% percent label
        formatter.setLocalizedDateFormatFromTemplate("yyyy")
        let fourtyPercentDate = eventModel.getYearsBy(percentage: 0.4)
        fourtyLabel.text = formatter.string(from: fourtyPercentDate)
        
        // 60% percent label
        let sixtyPercentDate = eventModel.getYearsBy(percentage: 0.6)
        sixtyLabel.text = formatter.string(from: sixtyPercentDate)
        
        // 80% percent label
        let eightyPercentDate = eventModel.getPassedYears(by: 0.8)
        eightyLabel.text = Helpers.string(of: eightyPercentDate)
        
        // 100% percent label
        let hundredPercentDate = eventModel.getPassedYears(by: 1.0)
        hundredLabel.text = Helpers.string(of: hundredPercentDate)
    }
    
    
    // MARK: - progress view
    func updateProgress(){
        let seconds = Float((hoursValue*60 + minutesValue)*60)
        let inc = 1.0/seconds
        
        progressBar.setProgress(progressBar.progress + inc, animated: true)
        displayEvent(at: Double(progressBar.progress), from: events)
       
    }
    
    // MARK: - Display events
    func displayEvent(at percent:Double, from events:[Event]){
        var i = 0
        while(i < events.count){
            let event = events[i]
            let roundedPercent = round(event.percentage * 1_000) / 1_000
            if roundedPercent <= percent {
                 print("event inside: \(event), percent: \(percent)")
                percentLabel.text = String(round(event.percentage * 10_000) / 100) + "%"

                if event.yearsAgo == -1 {
                    let dateString = Helpers.string(of: event.date)
                    dateLabel.text = dateString

                }else {
                    dateLabel.text = Helpers.string(of: event.yearsAgo)
                }

                var eventsText = ""
             
                let titles = event.titles
                for title in titles {
                    
                    eventsText += title + "\n"
                }
                eventsLabel.text = eventsText
//
                break
            }
           i = i + 1
        }
        
    }
    
    
    //MARK: - Self Defined Functions
    func updateTimer(){
        
        if seconds > 0 {
            seconds -= 1
        }else if minutes > 0 {
            seconds = 59
            minutes -= 1
        }else if hours > 0 {
            seconds = 59
            minutes = 59
            hours -= 1
        }else {
            timer.invalidate()
        }
        
        hourLabel.text = hours < 10 ? String("0\(hours)"):String(hours)
        minsLabel.text = minutes < 10 ? String("0\(minutes)"):String(minutes)
        secondsLabel.text = seconds < 10 ? String("0\(seconds)"):String(seconds)
    }
    
    func resetTimer(){
        // clear error message
        errorLabel.text = ""
        timer.invalidate()
        
        hours = hourTextField.text?.toHours() ?? -1
        minutes = minsTextField.text?.toMinutes() ?? -1
        progressBar.progress = 0.0
        percentLabel.text = ""
        dateLabel.text = ""
        eventsLabel.text = ""
        
        hoursValue = hours < 0 ? 0 : hours
        minutesValue = minutes < 0 ? 0 : minutes
        seconds = 0
    }
}

