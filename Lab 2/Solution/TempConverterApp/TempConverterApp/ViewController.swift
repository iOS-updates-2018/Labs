//
//  ViewController.swift
//  TempConverterApp
//
//  Created by Jordan Stapinski on 1/20/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  let tempConverter = TempConverter()
  
  @IBOutlet weak var showTemp: UILabel!
  @IBOutlet weak var showDegreesLabel: UILabel!
  @IBOutlet weak var showConvertLabel: UILabel!
  @IBOutlet weak var tempInput: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    showTemp.text = "--"
    self.tempInput.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    tempInput.resignFirstResponder()
    return true
  }
  
  @IBAction func convertTemp(_ sender: Any){
    let userData:String = tempInput.text!
    if (userData == "") {
      tempConverter.inputTemp = -500
    }
    else {
      if let tempValue = Int(userData){
        tempConverter.inputTemp = tempValue
      } else {
        tempConverter.inputTemp = -500
      }
    }
    tempConverter.convert()
    updateDisplay()
  }
  
  @IBAction func switchChanged(_ sender: UISwitch) {
    tempConverter.toggleUnits()
    updateLabels()
  }
  
  func updateDisplay() -> Void {
    showTemp.text = tempConverter.convertedTempDisplay
  }
  
  func updateLabels() -> Void {
    showConvertLabel.text = tempConverter.tempUnits
    showDegreesLabel.text = tempConverter.newUnits
  }


}

