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
    
    
    //MARK: - History Events UIs
    
    
    //MARK: - Custom Properties
    var timer:Timer = Timer()
    var hours = -1
    var minutes = -1
    var seconds = 0
    var eventModel:EventModal!
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
            
            // no error, initialize event modal with given time span in seconds
            let timespan = (hours * 24 + minutes) * 60
            eventModel = EventModal(timespanInSeconds: timespan)
            
            hourLabel.text = hours < 10 ? String("0\(hours)"):String(hours)
            minsLabel.text = minutes < 10 ? String("0\(minutes)"):String(minutes)
            secondsLabel.text = "00"
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
                [weak self] (_) in
                self?.updateTimer()
                
            })
            
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
        seconds = 0
    }
}

