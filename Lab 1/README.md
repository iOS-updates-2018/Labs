## Lab 1: TempConverter and Stopwatch ##

1. If you have not done so already, go to the App Store and download Xcode version 9.2+. After installing, open Xcode and agree to license and download command line tools and other needed components (should happen automatically after agreeing to license). **This download/installation may take 20-30 minutes, so please be prepared**.

2. In a separate window, open up the [Xcode Shortcuts Cheat Sheet](http://67442.cmuis.net/files/67442/XcodeShortcuts.pdf) by Yong Bakos. Refer to this cheat sheet throughout this lab to begin to learn the basic layout of Xcode as well as keyboard shortcuts that you may find useful.

### Part 1: Temp Converter (Swift)

1. Typically we will do the Swift exercise second, but since it's the first week and we want to keep this short we'll get started by going back to an old favorite from 67-272: Temp Converter. We'll start by creating a new Xcode playground named TempConverter (use the `File > New > Playground...` menu option) and save the playground in an appropriate place on your laptop.
    
  One quick tip before we continue, you may want to change the default indentation of the IDE in Xcode. To do this, click on "Xcode" in the top-left, then click on "preferences". Find the "Text Editing" pane and click on "indentation". Here, you can set the indentation to be anything you choose, but we recommend 2 spaces for everything.

2. In this playground, remove the default code and create a class called TempConverter as follows:
  ```swift
  class TempConverter { 
    private var temp: Int

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

5. Now, make the `convert` method into a static method. To change this around comment out the convert method and create a new one starting with the keyword `static` and in this case also passing in a second argument, `temp`.
  ```swift
    static func convert(temp: Int, unit: String = "F") -> Int {
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
      static func tempBelowAbsoluteZero(temp: Int, unit: String) -> Bool {
        return (temp < -454 && unit == "F") || (temp < -270 && unit == "C")
      }
  ```

  We now have a decent temp converter class and gotten our feet wet with Swift. We'll come back to this next week to do a little more, but for now let's move on to building our first iOS app.

### Part 2: Stopwatch (App)

For this part of the lab, we will now focus on creating our first actual iOS app: a stopwatch. At the end of this portion of the lab, you will have a working iOS stopwatch app that you can deploy onto your own iOS device (more on deployment later).

The final app should look as follows:

![Final Product](https://i.imgur.com/RO1FqmS.png)

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

11. We can save and build the project right now, but unfortunately our actions are pretty much useless and serving as just a placeholder right now. To make them more useful, we need a model that will handle the logic of finding the current time, calculating the elapsed time and converting that time into a string can be displayed through our outlet onto the time display label.  Add a new Swift file called 'Stopwatch.swift' and add the following code to create a basic framework for our model:

  ```swift
  import Foundation

  class Stopwatch {
    
    private var startTime: NSDate?

    func start() {

    }

    func stop() {

    }
     
  }
  ```

12. Before we write the code for this model, let's experiment with dates and times in Swift using a playground. (Playgrounds are great places for us to experiment with Swift code much like we did with rails console.)  Open a new playground and call it something like 'DatePlayground' (what you actually call it is not important).  Once it is open, add the following:

  ```swift
  import Foundation 

  let startTime: NSDate = NSDate()
  ```

  We see that when we create a new instance of `NSDate`, it defaults to the current datetime.  To create an older date is a little more effort, unfortunately, but it will give us a chance to play with `NSCalendar`.  Let's create two more dates in our playground with the following code:

  ```swift
  let calendar = NSCalendar.currentCalendar()

  let newYearsDayComponents = NSDateComponents()
  newYearsDayComponents.year = 2015
  newYearsDayComponents.month = 1
  newYearsDayComponents.day = 1
  let newYearsDay = calendar.dateFromComponents(newYearsDayComponents)! 

  let valentinesDayComponents = NSDateComponents()
  valentinesDayComponents.year = 2015
  valentinesDayComponents.month = 2
  valentinesDayComponents.day = 14
  valentinesDayComponents.hour = 9  // start the day at 9am for now
  let valentinesDay = calendar.dateFromComponents(valentinesDayComponents)!
  ```

  We can find the difference between these dates using the `timeIntervalSinceDate` method:

  ```swift
  let diffVD2NYD = valentinesDay.timeIntervalSinceDate(newYearsDay)
  let diffNYD2VD = newYearsDay.timeIntervalSinceDate(valentinesDay)
  ```

  What this is giving us is the time between these as seconds. In the case of `diffNYD2VD` the value is negative because when I subtract a larger number (Valentines Day) from a smaller number (New Years Day) it is negative, but that is easy to correct by multiplying by -1 if needed. What if I wanted the number of days between these dates? And what if after I wanted the number of hours that remained between them (since one starts at midnight and the other at 9am)?  We could do the following:

  ```swift
  let diffDays = Int(diffVD2NYD / 86400)
  let diffHours = Int((diffVD2NYD % 86400)/(3600))
  ```

  To combine these into a string (that I might send to update a view, for example) all we need to do is the following:

  ```swift
  let diffVD2NYDAsString: String = String(format: "%02d:%02d", diffDays, diffHours)
  ```

  Likewise, we can easily find the time that has elapsed from `startTime` and now with the following:

  ```swift
  var elapsedTime = startTime.timeIntervalSinceNow
  ```

13. Having played with dates and times in the playground, let's return to the model and start filling it out.  Replace the start and stop functions with the following:

  ```swift
  func start() {
    startTime = NSDate()
  }
  
  func stop() {
    startTime = nil
  }
  ```

  We have no problem with start, but as soon as I set `startTime` to nil in `stop()` we get an error.  What do I have to do to correct that error?  (Hint: in class on Thursday we discussed Optionals; that could be useful here.)

14. One thing I'd expect my model to do is calculate the elapsed time.  I can do this by adding the following method to my model:

  ```swift
  var elapsedTime: TimeInterval {
    if let startTime = self.startTime {
      return -1 * startTime.timeIntervalSinceNow // could also just say -startTime.timeIntervalSinceNow
    } else {
      return 0
    }
  }
  ```

  Remember that since we just made `startTime` an optional in the previous step, I need to unpack that optional safely here with the `if let ...` approach discussed in class.

  While this is nice, what we really need is a function that will return a string of format `00:00.0` (minutes,seconds,fractions of a second) that can be used by the ViewController to pass along to the view.  Write that function using the following starter code and drawing on lessons from our playground (you can test your ideas in the playground as well before writing the model method):

  ```swift
  var elapsedTimeAsString: String {
    // return the formatted string...
  }
  ```

15. One last thing we need in our model: a variable called `isRunning` which has two states:  true if the stopwatch is running and false otherwise. The existence of what variable indicates to us that the stopwatch is running? Use that information to create this simple variable now.

16. With the model done, we come back to the ViewController and create an instance of our model to work with. At the beginning of the class add the following:

  ```swift
  let stopwatch = Stopwatch()
  ```

  Now that we have an instance of Stopwatch to work with, we can add to our IBActions either `stopwatch.start()` or `stopwatch.stop()` as appropriate. Do that and then build and run the project. Problem is that still nothing is happening when I press start. Why? Well, I haven't updated the `elapsedTimeLabel` so there is no way to see what (if anything) I've done.

17. To fix this, create a method called `updateElapsedTimeLabel`. This will be a little tricky because we need this label to continually update until we press stop.  To do this, our method will take as an argument [Timer](https://developer.apple.com/documentation/foundation/timer); read the documentation linked to get an idea of what this class does. The code for our method is as follows:

  ```swift
  func updateElapsedTimeLabel(timer: Timer) {
    if stopwatch.isRunning {
      elapsedTimeLabel.text = stopwatch.elapsedTimeAsString
    } else {
      timer.invalidate()
    }
  }
  ```
  
  Now call this method just prior to `stopwatch.start` in the action with the following code:

  ```swift
  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateElapsedTimeLabel), userInfo: nil, repeats: true)
  ```

  You now need to annote the `updateElapsedTimeLabel` with the `@objc` attribute. This allows the function to be accessed and used by Objective-C. Swift and Objective-C can be used in the same project for more information about how this works read the [documentation](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html) linked. The method signature should now look like this:

  ```swift
    @objc func updateElapsedTimeLabel(timer: Timer)
  ```

#### Styling Your App

Now that your app is working, it's time to add a little style to it. 

18. Let's start by adding a background image. You can grab any image you would like. I personally like [unsplash.com](https://unsplash.com/wallpaper/1065412/iphone-wallpapers). All of the images here are licensed under Creative Commons Zero which means that you are free to use them however you would like. Find an image and save it to your project folder. 
    
    To add the image to the project, right click on the project folder and click "Add Files to [Project Name]" and find the image you had downloaded. If you are doing a larger project with multiple images, you should first create a Group within your project to organize all of your external assets better. 

  In order to handle different sized screens and layouts, Swift and XCode have what's called an Asset Catalog which allows you to upload different sized media for different devices. For this assignment we will keep it simple with just one size. Go into the Assets.xcassets and create a new Image Set called ```BackgroundImage``` you can do this by right clicking inside of the Assets Catalog and selecting "New Image Set". 

  Now drag the image from the project directory on the left to the "1X" section of the BackgroundImage Catalog. 

  Go to your Main.storyboard file and add an Image Layout to the story board and resize it so that it fits the entire screen. You will also want to move it to the back so that you can still see and click on the buttons. In the Attributes Inspector for the Image Layout select your background image and you now have a nice background image. 

  ![Asset Catalog](https://i.imgur.com/ymEH9Vu.png)

19. Some experts say that rectangles with rounded corners are easier on the eyes than a rectangle with sharp edges. So let's now add some rounded corners to the buttons. First select a button and then go to the Identity Inspector and add the following two User Defined Runtime Attributes: 
    * ```layer.masksToBounds``` - Boolean - True
    * ```layer.cornerRadius``` - Number - 15 (This could be any number you would like)

  Note that these changes will not affect the button until you run the app.

  ![Identity Inspector](https://i.imgur.com/moDGBau.png)

20. Finally, as a minor tweak, download the AppIcon for [Stopwatch](http://67442.cmuis.net/files/67442/lab3/AppIcon.appiconset.zip) and add this to your Images.xcassets folder, replacing the generic AppIcon set.  Rebuild your project and run it again.  When you press home (`shift`+`command`+`H`) you will see the new icon on the simulator home screen. As of Xcode 7.x you have the option to deploy directly to a device as well without a developer license, so if you plug in your iPhone to your laptop, you can also choose that device to deploy too as well.

  Feel free to change any other fonts and colors to make your app unique!

- - -
# <span class="mega-icon mega-icon-issue-opened"></span> Stop
**Be sure that the lab is checked-off by the TAs when complete. If for some reason you don't finish during this session, you may complete it on your own and show the TAs prior to the beginning of the next lab.**
- - - 
