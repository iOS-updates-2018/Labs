class TempConverter {
  var temp: Int
  
  init(temp: Int) {
    self.temp = temp
  }
  
  //  func convert(unit: String = "F") -> Int {
  //    if unit == "F" {
  //      return 5 * (self.temp - 32) / 9
  //    } else {
  //      return (9 * self.temp) / 5 + 32
  //    }
  //  }
  
  class func tempBelowAbsoluteZero(temp: Int, unit: String) -> Bool {
    return (temp < -454 && unit == "F") || (temp < -270 && unit == "C")
  }
  
  class func convert(temp: Int, unit: String = "F") -> Int {
    if tempBelowAbsoluteZero(temp: temp, unit: unit) {
      return -1000
    }
    if unit == "F" {
      return 5 * (temp - 32) / 9
    } else {
      return (9 * temp) / 5 + 32
    }
  }
}

let t = TempConverter(temp: 10)

//print(t.convert(unit: "F"))
//print(t.convert(unit: "C"))
//print(t.convert())

print(TempConverter.convert(temp: 50))
print(TempConverter.convert(temp: 10, unit: "C"))
print(TempConverter.convert(temp: -460, unit: "F"))

