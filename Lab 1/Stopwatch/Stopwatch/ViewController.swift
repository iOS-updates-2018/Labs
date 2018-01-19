//
//  ViewController.swift
//  Stopwatch
//
//  Created by Jordan Stapinski on 12/22/17.
//  Copyright © 2017 Jordan Stapinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var elapsedTimeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func startButtonTapped(sender: UIButton) {
    // code to start the clock
  }
  
  @IBAction func stopButtonTapped(sender: UIButton) {
    // code to stop the clock
  }

}

