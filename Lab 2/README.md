OBJECTIVES
===
- extend experience building iOS apps
- do some minor customization of the app interface
- provide a simple intro to multiple view controllers
- reinforce Swift programming knowledge
- introduce XCTest framework for testing
- refresh students on data structures fundamentals

CONTENTS
===
Part 1: Temp Converter (iOS app)
---
This lab will build off our TempConverter that we have been working with in 67-272 and in the previous lab and turn it into a working iOS app. The app will take some user input, convert it (if valid) from either Celsius to Fahrenheit or Fahrenheit to Celsius. There will also be a toggle switch to change the direction of the conversion and a simple about page describing your app. A sample screenshot of the app can be seen below. (You are free to use different colors, etc.; I just like blue.) 

<img src="https://i.imgur.com/tk5GBzl.jpg" width="350">

1. Create a new project which is a "Single View App" and call it "TempConverterApp". After you have the basic project, add a new Swift file called `TempConverter.swift` to hold your model. At the end of the lab is a partial model file if you are completely stuck and need a jump start to get going, but given your previous experience you can probably figure out an appropriate model on your own and I strongly urge you to try as it will maximize your learning experience. 

    The model should be able to convert Fahrenheit temps to Celsius and likewise convert Celsius to Fahrenheit if the user wants to go the other way. The model should be sure to have a variable which will interact with the ViewController to display the temperature as a string. This variable should either be the final temperature after conversion, or should display 'N/A' if the temperature the user inputs is invalid because it is either below absolute zero or is not a number. Check the code at the bottom of the lab for a better idea on this (using the variable `convertedTempDisplay`).

    After building up your model, check out the boilerplate code at the bottom of the instructions. This time, we are separating out the functions for Fahrenheit to Celsius and Celsius to Fahrenheit conversions, which allows for fewer conditionals in our code (and  abit more readable logic). You don't have to implement your model in this fashion, but at least take a look to get a sense of the differences in architecture between this model and the one we wrote last week.

2. Now we will move to the storyboard to mock up the interface. Open the `Main.storyboard` file in the XCode file explorer to see a blank iPhone canvas. For now we will just assume all temp conversions are from Fahrenheit to Celsius (will add the switch later) but we want to be mindful when we build the storyboard that the switch is coming and labels will have to adjust. Below is a screenshot of the initial storyboard to help guide you:

    ![Sliderless Interface](http://67442.cmuis.net/screenshots/67442/lab4/lab4-2.png)

    Adjust the view background to some color. Set the text field so that the input (which will be numerical) is right-aligned.  **Note that the final temp display is actually two different labels** -- one which will show the numeric value and the other to show the units it's being converted to. Later the units in that label will toggle when we hit a switch, so better to keep them separate from the start.  Also note that there are some [graphic resources](http://67442.cmuis.net/files/67442/lab4/resources_for_lab_4.zip) if you want to use them for customizing the button. (You must customize the button, but you can create your own resources if you want.) To add these resources, click on the `Assets.xcassets` folder, then hit the `+` button as seen in the screenshot below and choose `Import...` option and then navigate to your resources. Import any or all of the assets you wish. Once imported, you can use the `background` for the button to apply the appropriate image for the default button and then customize the text as you see fit. (You can also set up the highlighted state if you wish...)

    ![Assets Folder](https://i.imgur.com/6Xyf686.png)

3. In `ViewController.swift`, create some outlets that can be used for views to hook into. As we've seen before, outlets that are labels are of type `UILabel!`, but the `tempInput` outlet, for the input text field, is of type `UITextField!`. Once you have these outlets, wire them up to the storyboard (control-click, drag from Referencing Outlets to View Controller on the left). If you are stuck on how to create new outlets, check out the `ViewController.swift` file in the slider game code on the lectures portion of the course site.

4. In the view controller, create an instance of the TempConverter model that the controller can work with. In the function `viewDidLoad()` **be sure to set the initial tempLabel to "--"** (to represent our starting state). In the view controller you might also want to create a method called `updateLabels()` and another called `updateDisplay()` that other methods might call later, similar to what we did with the demo app in class. `updateLabels` will eventually update the temperature labels upon switching the input temperature (to be added later) while `updateDisplay` will update the final temperature label with the converted temperature, after converting the input temperature through the model.

5. Now we need to make an action in the View Controller that will convert the temperature when the button is pushed. My outlet for the text field is called `tempInput` and I can get the text from that outlet by typing `tempInput.text` If I just put in 

    ```swift
    let userData:String = tempInput.text
    ```

    then I get an error because the text field might not have any value and is an optional. I can force unpack it with `.text!` but then the interesting thing is that a blank text field will now have the value "". We can handle that case (set blank to -500 so the 'N/A' message appears) as follows:

    ```swift
    let userData:String = tempInput.text!

    if (userData == "") {
      converter.inputTemp = -500
    }
    else { ...
    ```

    Now we just have to convert `userData` from the string with the user's input to an int, which I could do with `Int(userData)`. But if the user puts in some nonsense text like 'tom brady', this method would return nil. How do we handle that? Treat it as an optional with `if let ...` and if it exists then just set the converter's input temp to that value; otherwise set to -500 as we did earlier.  Once the converter class instance's input temp is properly set in the ViewController, call the converter class instance's `convert()` method, update the temperature display in the View Controller and we are set.

    If you are stuck on this part, check out the [Swift Docs](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html) for help.

    Once you have this `@IBAction` function created, **don't forget to wire it up to the storyboard**! Build and run your app in the simulator to be sure it is working appropriately.

6. Now that this is working, we can go back to the storyboard and add a `UISwitch` element as well as some labels to indicate the direction of conversion. We can customize the switch using the attributes inspector on the right. We now need to create an action in the View Controller which will have the model toggle the units and then call our other View Controller method to update the temperature labels so we see the switch is working.  Below is a simple method to do so:

    ```swift
    @IBAction func switchChanged() {
      converter.toggleUnits()
      updateLabels()
    }
    ```

    Once you have the action, wire it up to the switch on the storyboard. A simple test in the simulator should show the temp labels toggle between C and F as the switch is tapped.

7. Finally, add an `info-light` button at the lower right corner of the app that will be used to take us to an about page. Then add a new file to the app -- make it a iOS source file of type `Cocoa Touch Class` and then call it `AboutViewController` and make it a subclass of `UIViewController` as seen below:

    ![Cocoa Touch Class](https://i.imgur.com/DCrVS4e.png)
    ...
    ![AboutViewController](https://i.imgur.com/fs1y0Eg.png)

    Once you have that file, replace its contents with the following code:

    ```swift
    import UIKit

    class AboutViewController: UIViewController {
    
      override func viewDidLoad() {
        super.viewDidLoad()
      }
    
      @IBAction func close() {
        dismiss(animated: true, completion: nil)
      }
    }
    ```

8. Go back to the storyboard and drag a `ViewController` object onto it to the right of the main view. Select that new `ViewController` object and go to the `identity inspector` (third icon from the left in the upper right; there are tooltips to help) and make sure that the class is set to `AboutViewController`.  Add a `TextView` object to the new view controller and replace the lorem ipsum text with something more appropriate. Add a close button beneath that and wire it up to the close action in `AboutViewController`. Finally create a seque between the two view controllers by clicking over the info button while holding `control` and dragging the cursor from the info button in the main view controller to the about view controller; choose the `show` option and your two view controllers will be connected as seen below:

    ![](http://67442.cmuis.net/screenshots/67442/lab4/lab4-6.png) 

9. To this point you've likely been running your app in the simulator and using your laptop keyboard for input. Now try to deploy the app to your iPhone by plugging in your device via USB and selecting it rather than iPhone 8 Plus simulator. (May take a few moments for your laptop to finish its usual updating whenever a device is connected before you can actually deploy.) Move the switch and see the labels update appropriately. Hit the convert button without entering any data and see "N/A" appear. Try typing data into the box and you run into a problem -- you can't submit and the keyboard is in the way and can't be dismissed.  (Finding this snafu is an example of why it's nice to test on a device.) We are going to solve the problem for you, but the full explanation will have to come a little later once we've talked about delegates and the use of the delegation pattern. For now, stop the deploy and go back the the ViewController code.

10. We need to tell the ViewController to adopt the UITextFieldDelegate protocol; to do that change the first line of the original View Controller to now read as follows:

    ```swift
    class ViewController: UIViewController, UITextFieldDelegate { ...
    ```

    Now in the method `viewDidLoad` add to the end of the method the following line: 

    ```swift
    self.inputTemperature.delegate = self
    ```

    Finally, add the following method to the ViewController:

    ```swift
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      inputTemperature.resignFirstResponder()
      return true
    }
    ```

    Redeploy to your device and see that this now works fine.  Of course, we might want other things to happen too, such as the text field automatically clearing or being selected when the app opens or automatically convert the temp when return is hit and as we learn more about delegates and the UITextFieldDelegate we can go back and modify this app as we see fit.  

11. Our app works, but we can make it look prettier. This part is optional, but feel free to use the techniques introduced at the end of th elast lab to make our app more visually astonishing! The background photo used can be found [here](https://unsplash.com/photos/aQ0S_jhEm0w).

Now, onto a quick refresher of data structures so we can sharpen our Swift skills.


Part 2: Stacks and Queues (Swift)
---

Over the next few weeks we are going to review some basic data structures using Swift. The purpose is twofold: first, to help you get more familiar with the Swift language and second, to help refresh your knowledge of basic data structures in advance of fall job interviews.  We are starting today with stacks and queues and will do a little review of each.

### Stacks

Let's start with **stacks**.  A stack is like an array but with limited functionality. You can only *push* to add a new element to the top of the stack, *pop* to remove the element from the top, and *peek* at the top element without popping it off.

  Why would you want to do this? Well, in many algorithms you want to add objects to a temporary list at some point and then pull them off this list again at a later time. Often the order in which you add and remove these objects matters.

  A stack gives you a LIFO or last-in first-out order. The element you pushed last is the first one to come off with the next pop.

  For our stack, we will represent the end of an array as the top of the stack, meaning this is where elements are pushed/popped from.

  For example, let's push a number on an initially empty stack `[ ]`:

  ```swift
  stack.push(10)
  ```

  The stack is now `[ 10 ]`. Push the next number:

  ```swift
  stack.push(3)
  ```

  The stack is now `[ 10, 3 ]`. This is because we will choose to represent the end of our array as the top of our stack, where elements are pushed/pulled from. Push one more number:

  ```swift
  stack.push(57)
  ```

  The stack is now `[ 10, 3, 57 ]`. Let's pop the top number off the stack:

  ```swift
  stack.pop()
  ```

  This returns `57`, because that was the most recent number we pushed. The stack is `[ 10, 3 ]` again.

  ```swift
  stack.pop()
  ```

  This returns `3`, and so on. If the stack is empty, popping returns `nil` or in some implementations it gives an error message ("stack underflow").

#### Stacks Requirements

1. A stack is easy to create in Swift. It's just a wrapper around an array that just lets you push, pop, and peek. To get you started, we've created a basic playground with a little framing in place. Grab the [starter files for lab2](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%202/Starter) and open up the `Stack_lab2.playground`.  In it you have been given a basic shell for a stack and some simple print tests that should help confirm if you set your stack up properly.  Add the code to the appropriate places and verify that everything is in working order.


2. Finally, we'd like to be able to confirm our data structures with something more rigorous than just the informal testing of a playground. In the [starter files for lab2](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%202/Starter) there is a folder called 'StackTests' - open `Tests.xcodeproj` with XCode and replace your code in the gaps of the `Stack.swift` file.  Then to run the tests, hover over the `Run` button in upper left corner of XCode until you see a little triangle appear; hold that down and the `test` option (with image of a wrench) will appear as the second option - select that option to run the tests.  Verify that all your tests passed. Looking at the test code (read it so you understand what is being tested and how) you see green checkmarks to passing tests. Change one of the tests so that it fails and rerun to see how XCode handles failing tests, but then revert it back so you can be checked off by the TAs.

### Queues

Now let's turn to a very similar data structure: **queues**. A queue is a list where you can only insert new items at the back and remove items from the front. This ensures that the first item you enqueue is also the first item you dequeue. We often refer to a queue as FIFO or first-in, first-out order. Since the element you inserted first is also the first one to come out again, using queues to manage events, etc. tend to appeal to our sense of fairness. 

  Why would you need this? Well, in many algorithms you want to add objects to a temporary list at some point and then pull them off this list again at a later time. Often the order in which you add and remove these objects matters.

  For example, let's enqueue a number:

  ```swift
  queue.enqueue(10)
  ```

  The queue is now `[ 10 ]`. Add the next number to the queue:

  ```swift
  queue.enqueue(3)
  ```

  The queue is now `[ 10, 3 ]`. Note here we will designate the first element of the array as the front of the queue, and enqueue new elements to the end of the array. Add one more number:

  ```swift
  queue.enqueue(57)
  ```

  The queue is now `[ 10, 3, 57 ]`. Let's dequeue to pull the first element off the front of the queue:

  ```swift
  queue.dequeue()
  ```

  This returns `10` because that was the first number we inserted. The queue is now `[ 3, 57 ]`. Everyone moved up by one place.

  ```swift
  queue.dequeue()
  ```

  This returns `3`, the next dequeue returns `57`, and so on. If the queue is empty, dequeuing returns `nil` or in some implementations it gives an error message.

#### Queues Requirements

1.  In the [starter files for lab2](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%202/Starter) find and open up the `Queue_lab2.playground`.  In it you have been given a basic shell for a queue and some simple tests that should pass if you set your queue up properly.  Add the code to the appropriate places and verify that everything is in working order.


2. Now we will write a similar test suite for the queue and test it. In the [starter files for lab2](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%202/Starter) there is a folder called 'QueueTests' - open `Tests.xcodeproj` with XCode and replace your code in the gaps of the `Queue.swift` file. Then, check out the tests in `QueueTests.swift` and add in XCTests for the functions given. For more on XCTest syntax, check out the `StackTests.swift` file from before.


- - -
# <span class="mega-icon mega-icon-issue-opened"></span> Stop
**Below is some starter code to give you hints about how to get moving. Do not use this code until after you have tried to do these tasks on your own.**
- - -

Model starter code:
---
  ```swift
  import Foundation

  class TempConverter {
    var inputTemp: Int = 0
    var convertedTemp: Int = 0
    var convertedTempDisplay: String = "0"
    var tempUnits: String = "°F"
    var newUnits: String = "°C"

    // Separated functions to check the absolute value cases, by unit
    private func tempBelowAbsoluteZeroFtoC(temp: Int) -> Bool {
    }
    
    private func tempBelowAbsoluteZeroCtoF(temp: Int) -> Bool {
    }
    
    // Separated functions for temperature converstion, by unit
    private func convertFtoC(temp: Int) -> Int {
    }
    
    private func convertCtoF(temp: Int) -> Int {
    }

    // Call the appropriate conversion function based on unit and update display variables
    func convert() {
    }
    
  }
  ```
