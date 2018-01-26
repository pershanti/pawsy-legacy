//
//  LocationViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/29/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var authUI: FUIAuth?
    var manager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBAction func skipLocation(_ sender: UIButton) {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        currentLocation = self.manager.location
        print(currentLocation!.coordinate.latitude)
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome"{
            if currentLocation != nil{
                let destination = segue.destination as! HomeViewController
                destination.currentLocation = self.currentLocation!
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
