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

class MapViewController: UIViewController, GMSMapViewDelegate  {


    var checkInTime: Date?
    var checkedInParkPlaceID: String?
    var checkInDocument: DocumentSnapshot?
    var checkInReference: DocumentReference?
    var clickedPark = Park(placename: "Select a Dog Park", id: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var currentLocation: CLLocation?
    var currentUser = Auth.auth().currentUser
    var db = Firestore.firestore()
    var dogCheckInReference: DocumentReference?
    var dogCurrentCheckInsReference: DocumentReference?
    var dogParkCheckInReference: DocumentReference?
    var dogParkReference: DocumentReference?
    var dogReference =  currentDog.sharedInstance.currentReference
    var list_of_parks = [String : Park]()
    var locationManager = CLLocationManager()
    var newCheckIn: CheckIn?
    var placesClient: GMSPlacesClient!
    var placeDoc: DocumentReference?
    var zoomLevel: Float = 15.0
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gmsmapView: GMSMapView!
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //Map Popup View Controller Delegate Functions
    func goToParkPage() {
        self.performSegue(withIdentifier: "goToParkPage", sender: self)
    }

    //Map Delegate functions

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.clickedPark = list_of_parks[marker.snippet!]!
        let vc = self.childViewControllers[0] as! MapPopupViewController
        vc.delegate = self
        vc.checkIfCheckedIn()
        vc.park = self.clickedPark
        vc.parkPageButton.setTitleColor(UIColor.blue, for: .normal)
        vc.dismissButton.setTitleColor(UIColor.blue, for: .normal)
        vc.checkInButton.setTitleColor(UIColor.blue, for: .normal)
        vc.viewDidLoad()
        return true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        getParks()
    }

    //Functions to set up the view
    override func viewDidLoad() {
        self.getLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        let popup = self.childViewControllers[0] as! MapPopupViewController
        popup.delegate = self
        popup.park = self.clickedPark
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


