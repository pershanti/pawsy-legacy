//
//  LocationViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/16/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    @IBAction func askForLocation(_ sender: UIButton) {
    
        self.locationManager.requestAlwaysAuthorization()
        self.performSegue(withIdentifier: "goToInput", sender: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
