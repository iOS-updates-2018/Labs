OBJECTIVES
===
- Teach students how to find and work with locations in iOS
- Teach students how to create maps and drop pins
- Reinforce previous mobile application development lessons


CONTENTS
===
This week, we will be making an app that allows users to track where their car is parked, and where they are relative to the car. We will be using maps, location, and plists to save car data. Here is a sneak peek at the final app, but let's dive in!

<p float="left">
  <img src="https://i.imgur.com/XN7zPNe.png" width="48%" />
  <img src="https://i.imgur.com/J72gI4C.png" width="48%" /> 
</p>

Part 1: Creating a basic map
---
1. Create a new "Single View App" project in Xcode called "FindMyCar". Once created, go to the main storyboard and on the first view add two buttons: "Here's My Car" and "Where's My Car?" This app is really designed for an iPhone, but you should still use Auto Layout constraints to make sure it works on different size phones (plus good practice). At this point, your app should look like the left screen above.

2. Create a new View Controller file called `MapViewController.swift` and drag a corresponding map view controller onto the main storyboard.  Make sure you connect that view to the `MapViewController` class. Connect the "Where's My Car?" button from the previous view to this new view, creating a segue; be sure to give the segue an identifier in the Attributes inspector.

3. In the new view, drag over a `Map Kit View` (about halfway down the options in the Object Library) and have it fill the view. Don't forget about Auto Layout!

4. Now we should add some navigation for a flow between the main title screen and the map. To do this, add in a `Navigation Controller`, remove its existing `Root View Controller`, and set the relationship to our main title screen view controller as `root view controller` (control-click and drag...). Be sure to set the navigation controller as the Initial View Controller!

5. In the `MapViewController.swift` file, add the directive `import MapKit` right after `import UIKit`. Go back to the Map storyboard and create an outlet called `mapView` for this MapKit View in the `MapViewController.swift` file (note this outlet should be of type `MKMapView`).

6. Now build the project and go to the map page in the simulator. Right now you are likely looking at a map of North America.  Glad that we got a map, but not all that helpful at the moment; not to worry, we will make it better soon.

7. In the `MapViewController` file add in the following code after the end of the `viewDidLoad()` function to help focus in on the area we really want to map:

    ```swift
    let regionRadius: CLLocationDistance = 400
    
    func centerMapOnLocation(location: CLLocation) {
      let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    ```

    Now replace the code in the `viewDidLoad()` method with the following code which will start us over a very familiar spot:

    ```swift
    super.viewDidLoad()
    let initialLocation = CLLocation(latitude: 40.4426092, longitude: -79.9454014)
    centerMapOnLocation(location: initialLocation)
    ```

8. Build this project again and see the results on the map page. The revised map should put us a lot closer to our current location.  Feel free to experiment with the `regionRadius` property (measured in meters) to find a radius that you like best. Also note you can hold down the `option` key in the simulator and drag around to perform a pinch-to-zoom effect.

Part 2: Adding in current location
---
1. Your simulator doesn't have GPS in it, but you can give it coordinates that it might have gotten from a GPS unit. To do this, go to your simulator and choose `Debug... Location...` and then choose the `Custom Location` option.  Add in the coordinates of (40.4454261, -79.9437277) for latitude and longitude, respectively.  These coordinates should put us in the Morewood parking lot. (A reasonable place to park one's car, except for that Tepper building...)

  ![Location](https://i.imgur.com/3PM6wJ7.png)

2. Go into the `info.plist` file found in the file explorer and add a new property list item called `NSLocationWhenInUseUsageDescription` and add in the text "This app would like to use your location." (this can be done by clicking the + icon shown by hovering over "Information Property List"). This is the message that will be displayed when your app requests permission from the phone to use location services.

3. Create a model file called `Location.swift`. After `import Foundation` add in the directive `import CoreLocation`.  Then add in the following code:

    ```swift
    class Location: NSObject {
    
      var latitude: CLLocationDegrees
      var longitude: CLLocationDegrees
      var locationManager = CLLocationManager()
    
      override init() {
        self.latitude = 0.00
        self.longitude = 0.00
        super.init()
      }
    
      func getCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()  
        if CLLocationManager.locationServicesEnabled() {
          locationManager.distanceFilter = kCLDistanceFilterNone
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          locationManager.startUpdatingLocation()
        }
        
        if let currLocation = locationManager.location {
          self.latitude = currLocation.coordinate.latitude
          self.longitude = currLocation.coordinate.longitude
        }
      }
    }
    ``` 

    Right now this class mostly tracks (and will later store) a location's latitude and longitude, but it also has the `getCurrentLocation()` method. One thing to note in `getCurrentLocation()` is that the first thing the app will do is verify that it has permission to use the phone's location services. The user will only have to give permission once (they can later change it in their phone's settings) but the app will always check to see that it has permission before calculating the current location. In some cases the initial granting of approval can take a second or two for the device to process, so the initial location will be at (0.00, 0.00) because the authorization hasn't been processed yet even though the user literally just gave permission. 

4. Back in the `MapViewController`, add `let location = Location()` after the outlet is declared. Then in the `viewDidLoad()` method, revise the code so it is as follows:

    ```swift
    super.viewDidLoad()
    location.getCurrentLocation()
    let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    centerMapOnLocation(location: initialLocation)
    ```

5. Actually, if you were to re-build the app, you may think it's working, but are you sure? Where are you on the map? It would be nice if we could drop on pin of our coordinates. Luckly, doing this in iOS is super easy; just add the following code to the end within the `viewDidLoad()` function:

    ```swift
    let droppedPin = MKPointAnnotation()
    droppedPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    droppedPin.title = "You Are Here"
    droppedPin.subtitle = "Look it's you!"
    mapView.addAnnotation(droppedPin)
    ```
    Rerun the project to see the pin and the title beneath.

    ![Pin](https://i.imgur.com/FJ8T2sc.png)

6. Note the subtitle after you click on the pin. Now replace these five lines with a helper method within `MapViewController` which performs this pin-dropping action and is called in `viewDidLoad()`.


Part 3: Finding and mapping car location and current location
---

1. We want to go back to the main view controller and add an action that we can connect to the "Here's my car" button. First, we need to create a new instance of the `Location` class within the `ViewController` class. This new action to be created in the `ViewController` class should find our current location using the method we already have in the `Location` class and then store it in the new location object instance. 

2. Once location has been updated, an alert should pop up to let us know the data has been saved. The title of the alert should just be "Car Location Saved" and the message for now will be a little verbose; below is a method to generate that message:

    ```swift
    func generateMessage() -> String {
      let message = "Your car is currently at: \n( \(location.latitude), \(location.longitude) )\n\nWhen you want a map to this location, simply press the 'Where is my car?' button."
      return message
    }
    ```

    Run your project and verify it is working as expected by tweaking the locations in the simulator to map to different locations.  FYI, the British Prime Minister's home is at (51.5034070, -0.1275920) and the White House is at (38.8976090, -77.0367350) if you want to try funky, non-Pittsburgh places to test. Here is an example of the alert:

    ![Alert](https://i.imgur.com/VRWeNxZ.png) 

3. Going back, we want to test that the location we saved is reflected upon pressing the "Where's my car?" button. The action associated with the button is just a segue to the `MapViewController`, so all we need to do is make sure in the `MapViewController` that the pin we dropped earlier on our current location is eliminated and a new pin is now dropped on the current car's location. Feel free to also change the Title/Subtitle of the pin accordingly. In addition, change the map to center to on the car's location and not the initial location as we did earlier.

4. We know where our car is and there is a pin dropped on the map to make it clear, but it'd be nice if we knew that location relative to our current position. This is easy. Go to the attributes inspector for the map view object in our storyboards and check the "User Location" item in the map view attributes. Check it now and rebuild. In the simulator, assuming the car is still parked in Morewood (40.4454261, -79.9437277), change the location to Wean Hall (40.4426092, -79.9454014). When you press on the show me the car button, the red pin drops on the car and your location has a blue glowing button.  In a real mobile device with GPS, this blue dot will readjust as you move. 

Part 4: Saving State
---

Now we will take a look at implementing a way to save our car's state no matter what may happen to our device: the app dies or the phone shuts down to name a few. We will do this for now by using a plist file, which is essentially writing some information to a file. In future weeks we will talk about using CoreData, which is an iOS framework for accessing internal memory similar to a database.

You can see the [Contacts example from lecture](https://github.com/profh/67442_ContactsLite) as a means of implementing plists in an app to save state.

For now, let's step through the steps to implement saving and loading our coordinates in the `Location` object.

#### Augmenting the Location Class

1. Let's begin by adding this string extension to the top of the `Location.swift` file (outside of the `Location` class):

    ```swift
    extension String {
      // recreating a function that String class no longer supports in Swift 2.3
      // but still exists in the NSString class. (This trick is useful in other
      // contexts as well when moving between NS classes and Swift counterparts.)
      
      /**
       Returns a new string made by appending to the receiver a given string.  In this case, a new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
       
       - parameter aPath: The path component to append to the receiver. (String)
       
       - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
       
      */
      func stringByAppendingPathComponent(aPath: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(aPath)
      }
    }
    ```

    This extension allows us to append a filepath component to a given string, allowing us to create the filepath we will need to the plist file.

2. Now, we must define the Swift functions *inside the `Location` class* to retrieve the appropriate directory for our plist file and the appropriate final filepath including our plist file in the device's memory:

    ```swift
    func documentsDirectory() -> String {
      let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
      return paths[0]
    }
    
    func dataFilePath() -> String {
      return documentsDirectory().stringByAppendingPathComponent(aPath: "Coordinates.plist")
    }
    ```

    We should then print the dataFilePath out of the `init` function, so let's add that now as well.

3. Now we are ready to write a function to save the location of the car which we will later call in several places around our app's files. This function will take our current latitude and longitude and save it to the plist. Add the `saveLocation` function in the `Location` class:

    ```swift
    func saveLocation() {
      let data = NSMutableData()
      let archiver = NSKeyedArchiver(forWritingWith: data)
      archiver.encode(self.latitude, forKey: "latitude")
      archiver.encode(self.longitude, forKey: "longitude")
      archiver.finishEncoding()
      data.write(toFile: dataFilePath(), atomically: true)
    }
    ```

4. Similarily, below the `saveLocation` function, add the `loadLocation` function which we will call to retrieve the latitude and logitude from the plist and save them to our location object:

    ```swift
    func loadLocation() {
      let path = dataFilePath()
      if FileManager.default.fileExists(atPath: path) {
        if let data = NSData(contentsOfFile: path) {
          let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
          self.latitude = unarchiver.decodeDouble(forKey: "latitude")
          self.longitude = unarchiver.decodeDouble(forKey: "longitude") 
          unarchiver.finishDecoding()
        } else {
          print("\nFILE NOT FOUND AT: \(path)")
        }
      }
    }
    ```

5. We should also write a function to clear out our latitude and longitude before saving. Add the `clearCarLocation` file to the `Location` class:

    ```swift
    func clearCarLocation () {
      self.latitude = 0.00
      self.longitude = 0.00
    }
    ```

6. The last thing we need to do is update our `getCurrentLocation` function in the `Location` class to clear the car's location and save the updated location to the plist. Call `clearCarLocation` to the beginning of this function, and call `saveLocation` right at the end.

#### Augmenting the MapViewController

The only thing that needs to be done is to switch the call to `getCurrentLocation` to `loadLocation` so we load from the plist.

#### Augmenting the ViewController

All that needs to be done here is to save the location of the car to our plist in the `saveCar` function attached to the button in the UI. Call the function to save to the plist at the end of this function.

#### Augmenting the AppDelegate

For `AppDelegate.swift` we must invoke our actions to save and load the location of the car on various triggers.

The car's location should be saved in:

* `applicationWillResignActive`
* `applicationDidEnterBackground`
* `applicationWillTerminate`

While the car's location should be loaded in:

* `application`
* `applicationWillEnterForeground`

Now the plist should be fully integrated into the app! Try adding location, killing the app, and checking to see it is there. If you are having issues with the plist, be sure it is being saved properly to the path printed when the `Location` object is initialized.
