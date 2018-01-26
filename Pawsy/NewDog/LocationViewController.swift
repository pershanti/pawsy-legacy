//
//  LocationViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/11/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    var currentLocation: CLLocation?

    @IBAction func locationCheck(_ sender: UIButton) {
        
        manager.requestWhenInUseAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.currentLocation = locations[0]
            performSegue(withIdentifier: "walkthroughDone", sender: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            self.manager.startUpdatingLocation()
            performSegue(withIdentifier: "walkthroughDone", sender: self)
        }
            
        else if status == CLAuthorizationStatus.denied{
            manager.requestWhenInUseAuthorization()
            performSegue(withIdentifier: "walkthroughDoneWithNoLocation", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "walkthroughDone"{
            let destination = segue.destination as! LaunchViewController
            destination.location = self.currentLocation
        }
        else if segue.identifier == "walkthroughDoneWithNoLocation"{
            let destination = segue.destination as! LaunchViewController
            destination.locationDenied = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


