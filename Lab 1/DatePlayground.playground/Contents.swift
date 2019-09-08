import Foundation

let startTime: NSDate = NSDate()
//let calendar = NSCalendar.currentCalendar()
//error: DatePlayground.playground:4:42: error: cannot call value of non-function type 'Calendar'
let calendar = Calendar.current
// using Calendar instead of NSCalendar --
// NS prefix dropped from certain Foundation classes from iOS 10 onwards

let newYearsDayComponents = NSDateComponents()
newYearsDayComponents.year = 2015
newYearsDayComponents.month = 1
newYearsDayComponents.day = 1
//let newYearsDay = calendar.dateFromComponents(newYearsDayComponents)!
//error: DatePlayground.playground:6:19: error: value of type 'Calendar' has no member 'dateFromComponents'
let newYearsDay = calendar.date(from: newYearsDayComponents as DateComponents)!
// converting newYearsDayComponents from NSDateComponents to DateComponents


var valentinesDayComponents = DateComponents()
valentinesDayComponents.year = 2015
valentinesDayComponents.month = 2
valentinesDayComponents.day = 14
valentinesDayComponents.hour = 9  // start the day at 9am for now
let valentinesDay = calendar.date(from: valentinesDayComponents)!

//let diffVD2NYD = valentinesDay.timeIntervalSinceDate(newYearsDay)
//error: DatePlayground.playground:20:18: error: value of type 'Date' has no member 'timeIntervalSinceDate'
let diffVD2NYD = valentinesDay.timeIntervalSince(newYearsDay)
let diffNYD2VD = newYearsDay.timeIntervalSince(valentinesDay)

let diffDays = Int(diffVD2NYD / 86400)
//let diffHours = Int((diffVD2NYD % 86400)/(3600))
//error: DatePlayground.playground:27:33: error: '%' is unavailable: Use truncatingRemainder instead
let diffHours = Int((diffVD2NYD.truncatingRemainder(dividingBy: 86400))/(3600))
let diffVD2NYDAsString: String = String(format: "%02d:%02d", diffDays, diffHours)
var elapsedTime = startTime.timeIntervalSinceNow
