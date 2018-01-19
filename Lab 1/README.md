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

    We now have a decent temp converter class and gotten our feet wet with Swift. We'll come back to this next week to do a little more, but for now let's move on to building our first iOS app.

### Part 2: Stopwatch (App)

For this part of the lab, we will now focus on creating our first actual iOS app: a stopwatch. At the end of this portion of the lab, you will have a working iOS stopwatch app that you can deploy onto your own iOS device (more on deployment later).

The final app should look as follows:

**FINAL APP IMAGE**

Now to actually construct it.

1. First, we will need to setup a new XCode project. To do this, open XCode, and then either navigate to `File > New > Project` or use the `shift-command-N` keyboard shortcut. From here, choose the `Single View App` option and click `Next` on the bottom right. Set the Project Name to be **Stopwatch** and then click `Next`. You can uncheck the three options at the bottom if you wish, we will learn about them in the coming weeks.

    ![Opening New Project](https://i.imgur.com/m1C7DBz.png)

2. XCode now opens a larger interface than you used for the `TempConverter` playground from before. If you click on the files on the left, the will open in the middle pane of the UI. Check out the contents of some of the files, including `AppDelegate.swift` and `ViewController.swift`, just skimming the files to get a sense of what they are about.

3. Now, we will take a look at the `MainStoryboard.swift` file, which is used to, in short, graphically manage elements on the iOS device's screen. If you click the **Close left tab** button on the bottom of the middle pane, then you can maximize the middle, graphical pane.

    Click the main canvas rectangle. Notice how there are now options on the right side (also known as the Inspector Pane) for you to investigate. In the Inspector Pane, click the leftmost icon on the top bar (this should look like a folded piece of paper, this is the File Inspector option). Here, uncheck the `Use Auto Layout` option.

    A dialog should ask if you wish to disable the Trait Variations option. Do so as well. We will talk about the importance of Auto Layout for creating responsive UIs later in the semester. For now, we will optimize for one screen size.

4. With that done, now note that the bottom portion of the rightmost pane contains a list of ViewController elements for you to use in your application. Here find the `Label` object and drag it onto the interface. Now, go back to the inspector pane and click the downward-arrow looking item in the top bar (also known as the attribute inspector). Now, change the starting text to '00:00.0', the font color to blue, and the size to be reasonably large.

5. Now add two `Button` objects to the interface in the same manner you did with the `Label` in step 4. Set one to have a green background and have the label 'Start', and the other one to have a red background and have the label 'Stop'. At this point, your interface should look something like the one below:

    ![Interface after buttons](https://i.imgur.com/RkpJhkS.png)

6. Now, this might not be 272, but that doesn't mean we can forget about source control! Put this project into a Git repository from the command line and commit our progress so far.

7. XCode features handy iOS simulators which we can use to test our app without deployment. In the upper-left of the XCode UI is a Play Button (>) that will build the project and run it on a simulator. By default, XCode will build this project to an iPhone 8 Plus simulator, but this can be changed by clicking 'iPhone 8 Plus' nearby in the top left corner. Run the build and see it works on the simulator (aside from the buttons working as expected, but we will fix that next).

8. Now we are going to have to create functions which will be called upon clicking the `Start` and `Stop` buttons. These actions are written in the `ViewController.swift` file. Go there and add the following functions:

  ```swift 
  @IBAction func startButtonTapped(sender: UIButton) {
    // code to start the clock
  }

  @IBAction func stopButtonTapped(sender: UIButton) {
    // code to stop the clock
  }
  ```

9. Now in the storyboard, it's time to "wire up" each button to its respective action. To do this, click on a button while holding the control key and drag the cursor to the `View Controller` as seen in the image below. When you release, the popup that you see in the image should appear and just select the action you want associated with the button. Verify that this was done correctly by looking at the Connections Inspector (last icon on the right in the rightmost Inspector Pane) and seeing the connection of each button to their respective actions.

    ![Interface Wiring](https://i.imgur.com/6vULX0N.png)

10. We now need an Outlet variable for the time display. Add this line to the top of the `ViewController` class.

    ```swift
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    ```

    Now connect the outlet by selecting our time display label while holding the control key. A series of options pops up. Under `Referencing Outlets` there is a suboption for `New Referencing Outlet` and there is an open circle at the end of the option. Holding the control key, click and drag that circle to the `View Controller` under the `View Controller Scene` to the left of the storyboard. When you let go, you should get a option for the outlet we added, `elapsedTimeLabel`; select that option. Again, the Connections Inspector should verify the connection was properly made.
