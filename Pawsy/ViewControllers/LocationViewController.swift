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

class LocationViewController: UIViewController {
    
    var authUI: FUIAuth?
    var manager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBAction func skipLocation(_ sender: UIButton) {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        self.manager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome"{
            if currentLocation != nil{
                let destination = segue.destination as! HomeViewController
                destination.delegate = self
                destination.currentLocation = self.currentLocation!
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        print(currentLocation!)
        performSegue(withIdentifier: "goToHome", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
