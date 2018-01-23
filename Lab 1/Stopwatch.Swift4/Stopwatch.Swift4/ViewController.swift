//
//  ViewController.swift
//  Stopwatch.Swift4
//
//  Created by Kenny Cohen on 1/23/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let stopwatch = Stopwatch()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonTapped(sender: UIButton) {
        updateElapsedTimeLabel(timer: Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateElapsedTimeLabel), userInfo: nil, repeats: true))
        stopwatch.start()
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        stopwatch.stop()
    }
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    @objc func updateElapsedTimeLabel(timer: Timer) {
        if stopwatch.isRunning {
            elapsedTimeLabel.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }

}

