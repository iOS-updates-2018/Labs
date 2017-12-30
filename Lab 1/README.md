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
  
    Below the `TempConverter` class, create an instance of the `TempConverter` class with the line:
    ```swift
    let t = TempConverter(temp: 10)
    ```

3. Now we want to add a convert method that will convert the temperature into Fahrenheit or Celsius, depending on what we specify. We can do this with a method similar to what we used in 67-272 inside of the `TempConverter` class:
  ```swift
  func convert(unit: String) -> Int {
    if unit == "F" {
      return 5 * (self.temp - 32) / 9
    } else {
      return (9 * self.temp) / 5 + 32
    }
  }
  ```
  
    You've now defined a function to convert temperature that takes in a parameter `unit` of the type `String` and that it will return an `Int` by typing `-> Int` where the function is declared.

    To test this in our playground, right below where we create `t`, add the following:

    ```swift
    print(t.convert("F"))
    ```

    Note: you may have to click on the "show/hide debug area" button in the bottom left -- it's a square with a triangle in it -- to see the print out. Add a second line that replaces `"F"` with `"C"` and see that it works properly.

4. This is nice, but we'd like the method to default to `"F"` if no argument was passed. To make this change, simply specify the default value in method definition `convert(unit: String = "F")`. Now remove any arguments from the print statement and see that it works as expected for Fahrenheit. Note to use Celsius we need to explicitly set the unit to `"C"`.

5. Now, make the `convert` method into a class method. To change this around comment out the convert method and create a new one starting with the keyword `class` and in this case also passing in a second argument, `temp`.
  ```swift
  class func convert(temp: Int, unit: String = "F") -> Int {
    if unit == "F" {
      return 5 * (temp - 32) / 9
    } else {
      return (9 * temp) / 5 + 32
    }
  }
  ```

    Note that defining `convert` as a class method allows for a subclass to override this method, while defining `convert` as a static method would not.

    We can display the outputs through adding some print statements:

    ```swift
    print(TempConverter.convert(50))
    print(TempConverter.convert(temp: 10, unit: "C"))
    print(TempConverter.convert(temp: -460, unit: "F"))
    ```

    **Oops!** Note that we forgot the `temp` label in the top print statement. Fortunately, the XCode interface highlights this and suggests a fix. Go ahead and add the temp label back into this print statement.

6. The last case reminds us that we have to account for absolute zero like we did in 67-272. To make things easy for now, let's just say the temp of anything in the absolute zero range is -1000. So in the `convert` function add in the following code right at the top of the function:
  ```swift
  if tempBelowAbsoluteZero(temp: temp, unit: unit) {
    return -1000
  }
  ```

    As you’ve probably noticed this conditional will be calling a helper function. Add in the following code lower in the class to make this line work.

    ```swift
    class func tempBelowAbsoluteZero(temp: Int, unit: String) -> Bool {
      return (temp < -454 && unit == "F") || (temp < -270 && unit == "C")
    }
    ```

### Part 2: Stopwatch (App)

