//
//  ViewController.swift
//  FindMyCar
//
//  Created by Jordan Stapinski on 2/1/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let location = Location()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func saveCar(button: UIButton!){
    location.getCurrentLocation()
    let alert = UIAlertController(title: "Saved", message: generateMessage(), preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
      print("Handle Ok logic here")
    }))
    present(alert, animated: true, completion: nil)
  }
  
  func generateMessage() -> String {
    let message = "Your car is currently at: \n( \(location.latitude), \(location.longitude) )\n\nWhen you want a map to this location, simply press the 'Where is my car?' button."
    return message
  }


}

