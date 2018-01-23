//
//  ViewController.swift
//  Stopwatch.Swift4
//
//  Created by Kenny Cohen on 1/23/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!

}

