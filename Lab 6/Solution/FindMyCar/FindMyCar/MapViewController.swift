//
//  MapViewController.swift
//  FindMyCar
//
//  Created by Jordan Stapinski on 2/1/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  let location = Location()

  override func viewDidLoad() {
    super.viewDidLoad()
    location.getCurrentLocation()
    let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    centerMapOnLocation(location: initialLocation)
      // Do any additional setup after loading the view.
    dropPin()
  }
  
  func dropPin(){
    let droppedPin = MKPointAnnotation()
    droppedPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    droppedPin.title = "You Are Here"
    droppedPin.subtitle = "Your Car"
    mapView.addAnnotation(droppedPin)
  }
  
  let regionRadius: CLLocationDistance = 400

  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
