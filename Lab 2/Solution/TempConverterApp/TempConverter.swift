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
  
  // Separated functions to check the absolute value cases, by unit
  private func tempBelowAbsoluteZeroFtoC(temp: Int) -> Bool {
    return temp < -454
  }
  
  private func tempBelowAbsoluteZeroCtoF(temp: Int) -> Bool {
    return temp < -270
  }
  
  // Separated functions for temperature converstion, by unit
  private func convertFtoC(temp: Int) -> Int {
    return 5 * (inputTemp - 32) / 9
  }
  
  private func convertCtoF(temp: Int) -> Int {
    return (9 * inputTemp) / 5 + 32
  }
  
  // Call the appropriate conversion function based on unit and update display variables
  func convert() {
    // logic for converting temps and setting display string
    // must check that the temp is valid (above absolute zero)
    // if temp is not valid, display string should be set to 'N/A'
    
    // Fahrenheit Case
    if tempUnits == "°F" {
      if tempBelowAbsoluteZeroFtoC(temp: inputTemp){
        convertedTempDisplay = "N/A"
      } else {
        convertedTemp = convertFtoC(temp: inputTemp)
      }
    // Celsius case
    } else {
      if tempBelowAbsoluteZeroCtoF(temp: inputTemp){
        convertedTempDisplay = "N/A"
      } else {
        convertedTemp = convertCtoF(temp: inputTemp)
      }
    }
    convertedTempDisplay = String(convertedTemp)
  }
  
  func toggleUnits() {
    let unitHold = tempUnits
    tempUnits = newUnits
    newUnits = unitHold
    // switch the state of tempUnits and newUnits
    
  }
}
