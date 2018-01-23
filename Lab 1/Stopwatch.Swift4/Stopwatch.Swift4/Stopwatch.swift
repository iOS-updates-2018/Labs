//
//  Stopwatch.swift
//  Stopwatch.Swift4
//
//  Created by Kenny Cohen on 1/23/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import Foundation

class Stopwatch {
    private var startTime: NSDate?
    private var _isRunning: Bool = false
    
    var isRunning: Bool{
        return _isRunning
    }
    
    func start() {
        startTime = NSDate()
        _isRunning = true
    }
    
    func stop() {
        _isRunning = false
        startTime = nil
    }
    
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -1 * startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    
    var elapsedTimeAsString: String {
        let time = elapsedTime
        let minutes = Int(time / 60)
        let seconds = time - (Double(minutes) * 60.0)
        return String(format: "%02d:%04.1f", minutes, seconds)
    }
}
