//
//  LocationViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/11/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class LocationViewController: UIViewController {
    
    var manager = CLLocationManager()
    var currentLocation: CLLocation?

    @IBAction func locationCheck(_ sender: UIButton) {
        
        manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        performSegue(withIdentifier: "walkthroughDone", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


