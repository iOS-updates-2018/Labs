## Lab 1: TempConverter and Stopwatch ##

1. If you have not done so already, go to the App Store and download Xcode version 9.2+. After installing, open Xcode and agree to license and download command line tools and other needed components (should happen automatically after agreeing to license). **This download/installation may take 20-30 minutes, so please be prepared**.

2. In a separate window, open up the [Xcode Shortcuts Cheat Sheet](http://67442.cmuis.net/files/67442/XcodeShortcuts.pdf) by Yong Bakos. Refer to this cheat sheet throughout this lab to begin to learn the basic layout of Xcode as well as keyboard shortcuts that you may find useful.

**Add in changing default indentation**

### Part 1: Temp Converter (Swift)

1. Typically we will do the Swift exercise second, but since it's the first week and we want to keep this short we'll get started by going back to an old favorite from 67-272: Temp Converter. We'll start by creating a new Xcode playground named TempConverter (use the `File > New > Playground...` menu option) and save the playground in an appropriate place on your laptop.

2. In this playground, remove the default code and create a class called TempConverter as follows:

```swift
class TempConverter { 
  var temp: Int

  init(temp: Int) {
    self.temp = temp
  }
}
```
