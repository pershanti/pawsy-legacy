//
//  MapViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/19/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import SwiftHTTP
import SwiftyJSON

class MapViewController: UIViewController, GMSMapViewDelegate, DogParkViewControllerDelegate  {

    //current dog singleton
    var dogReference =  currentDog.sharedInstance.currentReference

    //firebase user
    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser

    //check in variables
    var checkedIn = false
    var checkInTime: Date?
    var checkedInParkPlaceID: String?
    var checkInDocument: DocumentSnapshot?
    var checkInReference: DocumentReference?
    var dogCheckInReference: DocumentReference?
    var dogCurrentCheckInsReference: DocumentReference?
    var dogParkCheckInReference: DocumentReference?
    var newCheckIn: CheckIn?
    var placeDoc: DocumentReference?

    //currentpark singleton
     var dogParkReference: DocumentReference?

    //map variables
    var clickedPark = Park(placename: "Select a Dog Park", id: "")

    var list_of_parks = [String : Park]()
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    @IBOutlet weak var gmsmapView: GMSMapView!
    @IBOutlet weak var parkPageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!

    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        if self.checkedIn == false{
            self.checkedIn = true
            print("checkedIn")
            self.checkInButton.setTitle("Check Out", for: .normal)
            self.checkIn(clickedPark: self.clickedPark)
        }
        else if self.checkedIn == true {
            self.checkedIn = false
            print("checkedOut")
            self.checkInButton.setTitle("Check In", for: .normal)
            self.checkOut()
        }
    }

    @IBAction func goToParkPageButton(_ sender: UIButton) {
              self.performSegue(withIdentifier: "goToParkPage", sender: self)
    }

    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.parkNameLabel.text = "Select a Dog Park"
        self.parkPageButton.setTitleColor(UIColor.white, for: .normal)
        self.dismissButton.setTitleColor(UIColor.white, for: .normal)
        self.checkInButton.setTitleColor(UIColor.white, for: .normal)
    }

    //Map Delegate functions
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.clickedPark = list_of_parks[marker.snippet!]!
        self.parkNameLabel.text = marker.snippet
        self.parkPageButton.setTitleColor(UIColor.blue, for: .normal)
        self.dismissButton.setTitleColor(UIColor.blue, for: .normal)
        self.checkInButton.setTitleColor(UIColor.blue, for: .normal)
        return true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //updates the parks when the view changes
        getParks()
    }

    //Functions to set up the view
    override func viewDidLoad() {
        self.getLocation()
        self.checkIfCheckedIn()
    }

    //Sets up location Manager
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    //creates the map and sets the camera on the current location
    func setUpMap(){
        placesClient = GMSPlacesClient.shared()
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude, zoom: 14)
        self.gmsmapView.camera = camera
        gmsmapView.settings.zoomGestures = true
        gmsmapView.settings.myLocationButton = true
        gmsmapView.settings.scrollGestures = true
        gmsmapView.isMyLocationEnabled = true
        self.gmsmapView.clear()
        self.gmsmapView.delegate = self
        self.getParks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToParkPage"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! DogParkViewController
            vc.park = self.clickedPark
            vc.delegate = self
        }
    }
}


