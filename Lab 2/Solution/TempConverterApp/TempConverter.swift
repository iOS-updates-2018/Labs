//
//  TempConverter.swift
//  TempConverterApp
//
//  Created by Jordan Stapinski on 1/20/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import Foundation


class TempConverter {
  
  var inputTemp: Int = 0
  var convertedTemp: Int = 0
  var convertedTempDisplay: String = "0"
  var tempUnits: String = "°F"
  var newUnits: String = "°C"

  func convert() {
    if (!(tempIsValid())) {
      convertedTempDisplay = "N/A"
      return
    }
    if tempUnits == "°F" {
      convertedTemp = 5 * (inputTemp - 32) / 9
    } else {
      convertedTemp = (9 * inputTemp) / 5 + 32
    }
    convertedTempDisplay = String(convertedTemp)
    // logic for converting temps and setting display string
    // must check that the temp is valid (above absolute zero)
    // if temp is not valid, display string should be set to 'N/A'
    
  }
  
  func tempIsValid() -> Bool {
    return (inputTemp >= -454 && tempUnits == "°F") || (inputTemp >= -270 && tempUnits == "°C")
    // test to make sure above absolute zero for either Fahrenheit or Celsius
    
  }
  
  func toggleUnits() {
    let unitHold = tempUnits
    tempUnits = newUnits
    newUnits = unitHold
    // switch the state of tempUnits and newUnits
    
  }
}
