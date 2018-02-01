OBJECTIVES
===
- Teach students how to find and work with locations in iOS
- Teach students how to create maps and drop pins
- Reinforce previous mobile application development lessons


CONTENTS
===
Part 1: Creating a basic map
---
1. Create a new "Single View App" project in Xcode called "FindMyCar". Once created, go to the main storyboard and on the first view add two buttons: "Here's My Car" and "Where's My Car?" This app is really designed for an iPhone, but you should still use Auto Layout constraints to make sure it works on different size phones (plus good practice).

2. Create a new View Controller file called `MapViewController.swift` and drag a corresponding view onto the main storyboard.  Make sure you connect that view to the `MapViewController` class. Connect the "Where's My Car?" button from the previous view to this new view, creating a segue; be sure to give the segue an identifier in the Attributes inspector.

3. In the new view, drag over a `MapKit View` (about halfway down the options in the Object Library) and have it fill the view.

4. In the `MapViewController.swift` file, add the directive `import MapKit` right after `import UIKit`. Go back to the Map storyboard and create an outlet called `mapView` for this MapKit View in the `MapViewController.swift` file (note this outlet should be of type `MKMapView`).

5. Now build the project and go to the map page in the simulator. Right now you are likely looking at a map of North America.  Glad that we got a map, but not all that helpful at the moment; not to worry, we will make it better soon.

6. In the `MapViewController` file add in the following code after the `viewDidLoad()` function to help focus in on the area we really want to map:

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

7. Build this project again and see the results on the map page. The revised map should put us a lot closer to our current location.  Feel free to experiment with the `regionRadius` property (measured in meters) to find a radius that you like best.

Part 2: Adding in current location
---
1. Your simulator doesn't have GPS in it, but you can give it coordinates that it might have gotten from a GPS unit. To do this, go to your simulator and choose `Debug... Location...` and then choose the `Custom Location` option.  Add in the coordinates of (40.4454261, -79.9437277) for latitude and longitude, respectively.  These coordinates should put us in the Morewood parking lot. (A reasonable place to park one's car...)

1. Go into the `info.plist` file found in the Supporting Files folder and add a new property list item called `NSLocationWhenInUseUsageDescription` and add in the text "This app would like to use your location." This is the message that will be displayed when your app requests permission from the phone to use location services.

1. Create a model file called `Location.swift`. After `import Foundation` add in the directive `import CoreLocation`.  Then add in the following code:

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

1. Back in the `MapViewController`, add `let location = Location()` after the outlet is declared. Then in the `viewDidLoad()` method, revise the code as follows:

  ```swift
  super.viewDidLoad()
  location.getCurrentLocation()
  let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
  centerMapOnLocation(initialLocation)
  ```

  Rebuild the project and see that it is all working as it should.

1. Actually, you think it's working, but are you sure? Where are you on the map? It would be nice if we could drop on pin of our coordinates. Luckly, doing this in iOS is super easy; just add the following code to `viewDidLoad()`:

  ```swift
  let droppedPin = MKPointAnnotation()
  droppedPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
  droppedPin.title = "You Are Here"
  mapView.addAnnotation(droppedPin)
  ```
  Rerun the project to see the pin and click on the pin to get the title. Now clean up this code so `viewDidLoad()` calls an appropriate pin-dropping method with one line rather than these four lines.


Part 3: Finding and mapping car location and current location
---

1. We want to go back to the main view controller and add an action that we can connect to the "Here's my car" button. This action should find our current location using the method we already have in the `Location` class and then store it in location object. Once it has been handled, an alert should pop up to let us know the data has been saved. The title of the alert should just be "Car Location Saved" and the message for now will be a little verbose; below is a method to generate that message:

  ```swift
  func generateMessage() -> String {
    let message = "Your car is currently at: \n( \(location.latitude), \(location.longitude) )\n\nWhen you want a map to this location, simply press the 'Where is my car?' button."
    return message
  }
  ```

  Run your project and verify it is working as expected by tweaking the locations in the simulator to map to different locations.  FYI, the British Prime Minister's home is at (51.5034070, -0.1275920) and the White House is at (38.8976090, -77.0367350) if you want to try funky, non-Pittsburgh places to test. 

1. We want to make sure that this is all linked to the "Where's my car?" button. The action associated with the button is actually a seque to the MapViewController, so all we need to do is make sure in the controller that the pin we dropped earlier on our current location is eliminated and a new pin is now dropped on the car's location and the title associated with the pin should be changed to "Your Car" or something to that effect. In addition, change the map to center to on the car's location and not the initial location as we did earlier.

1. We know where our car is and there is a pin dropped on the map to make it clear, but it'd be nice if we knew that location relative to our current position. This is easy. Go to the attributes inspector for the map view object in our storyboards and the first (unchecked) item in the map view attributes is to show the user location. Check it now and rebuild. In the simulator, assuming the car is still parked in Morewood (40.4454261, -79.9437277), change the location to Wean Hall (40.4426092, -79.9454014). When you press on the show me the car button, the red pin drops on the car and your location has a blue glowing button.  In a real mobile device with GPS, this blue dot will readjust as you move. 

1. We will in future weeks tweak this lab and add some additional features (including saving the car data on the phone so it's not lost due to power failure, etc.) so be sure to save this code.  (If you want to explore on your own and make sure the data is saved, feel free to do so; exploration is a great way to learn.)  In the meantime, get cracking on that midterm exam prep. Qapla'
