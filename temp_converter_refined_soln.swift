//
//  temp_converter_refined_soln.swift
//  
//
//  Created by Jordan Stapinski on 8/19/18.
//

import Foundation

class TempConverter {
  static func tempBelowAbsoluteZeroFtoC(temp: Int) -> Bool {
    return temp < -454
  }
  
  static func tempBelowAbsoluteZeroCtoF(temp: Int) -> Bool {
    return temp < -270
  }
  
  static func convertFtoC(temp: Int) -> Int {
    if tempBelowAbsoluteZeroFtoC(temp: temp){
      return -1000
    }
    return 5 * (temp - 32) / 9
  }
  
  static func convertCtoF(temp: Int) -> Int {
    if tempBelowAbsoluteZeroCtoF(temp: temp){
      return -1000
    }
    return (9 * temp) / 5 + 32
  }
  
}

print(TempConverter.convertFtoC(temp: 50))
print(TempConverter.convertCtoF(temp: 10))
print(TempConverter.convertCtoF(temp: -460))

