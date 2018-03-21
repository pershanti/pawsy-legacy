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

class MapViewController: UIViewController, GMSMapViewDelegate, MapPopupViewControllerDelegate, DogParkViewControllerDelegate  {

    var checkedIn = false
    var checkedInReference: DocumentReference?
    var checkInTime: Date?
    var currentUser = Auth.auth().currentUser
    var locationManager = CLLocationManager()           
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var placeDoc: DocumentReference?
    var zoomLevel: Float = 15.0
    var list_of_parks = [String : Park]()
    var clickedPark = Park(placename: "Select a Dog Park", id: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var newCheckIn: CheckIn?
    var checkInReference: DocumentReference?
    var dogParkReference: DocumentReference?
    var dogParkCheckInReference: DocumentReference?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gmsmapView: GMSMapView!
    @IBOutlet weak var checkinButtonChange: UIBarButtonItem!

    //CheckIn and Check out Button Names
    @IBAction func checkInButton(_ sender: Any) {
        if self.checkedIn == false{
            self.checkedIn = true
            print("checkedIn")
            self.checkinButtonChange.title = "Check Out"
        }
        else{
            self.checkedIn = false
            print("checkedOut")
            self.checkinButtonChange.title = "Check In"
        }
    }
    //Navigation
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //Map Popup View Controller Delegate Functions
    func goToParkPage() {
        self.performSegue(withIdentifier: "goToParkPage", sender: self)
    }

    func checkIn(){
        let currentDogID = currentDog.sharedInstance.currentReference!.documentID
        //create a new check in and add it to a list of park check ins
        self.newCheckIn = CheckIn(cin: Date(), place: self.clickedPark.placeID!, dog: currentDogID, name: self.clickedPark.name!)
        self.checkInReference = Firestore.firestore().collection("allCheckIns").addDocument(data: ["checkInTime" : self.newCheckIn?.checkInTime!, "placeName": self.newCheckIn?.placeName, "placeID" : self.newCheckIn?.placeID!, "dogID" : self.newCheckIn?.dogID]){ (error) in
            //add the check in to a list specific to this dog park
            self.dogParkReference = Firestore.firestore().collection("dogParks").addDocument(data: ["placeName": self.newCheckIn?.placeName, "placeID":self.newCheckIn!.placeID!])
            self.dogParkCheckInReference =  self.dogParkReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])
        }
    }


    func checkOut(){
        self.newCheckIn?.checkOutTime = Date()
        //update the checkIn to add checkOut time
        self.checkInReference?.setData(["checkOutTime" : self.newCheckIn?.checkOutTime])
        //add the check in ID to the park's past check in page
        self.dogParkReference!.collection("pastCheckIns").addDocument(data: ["checkInID":self.checkInReference?.documentID])
        //add the check in ID to the dog's past checkIn page
        currentDog.sharedInstance.currentReference?.collection("pastCheckIns").addDocument(data: ["checkInID":self.checkInReference?.documentID]) { (error) in
            //delete references
            self.dogParkCheckInReference?.delete()
            self.checkInReference = nil
            self.dogParkReference = nil
            self.dogParkCheckInReference = nil
            self.newCheckIn = nil
        }
    }

    //Map Delegate functions

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.clickedPark = list_of_parks[marker.snippet!]!
        let vc = self.childViewControllers[0] as! MapPopupViewController
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


