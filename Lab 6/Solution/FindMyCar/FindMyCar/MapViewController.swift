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

    override func viewDidLoad() {
      super.viewDidLoad()
      let initialLocation = CLLocation(latitude: 40.4426092, longitude: -79.9454014)
      centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
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
