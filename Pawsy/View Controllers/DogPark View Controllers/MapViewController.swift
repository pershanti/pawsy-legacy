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

    //current dog singleton
    var signedInDog =  currentDog.sharedInstance
    //checked in park singleton
    var checkedInPark = CheckedInPark.sharedInstance

    //firebase user
    var dogCollection = Firestore.firestore().collection("dogs")
    var parkCollection = Firestore.firestore().collection("dogParks")
    var currentUser = Auth.auth().currentUser

    //map variables
    var clickedPark: Park?
    var list_of_parks = [String : Park]()
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    var checkedInParkName: String?

    @IBOutlet weak var gmsmapView: GMSMapView!
    @IBOutlet weak var parkPageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var parkNameLabel: UILabel!

    @IBAction func goToParkPageButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToParkPage", sender: self)
    }
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.parkNameLabel.text = ""
        self.parkPageButton.isEnabled = false
        self.dismissButton.isEnabled = false
    }
    //Map Delegate functions
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        self.clickedPark = list_of_parks[marker.snippet!]!
        //check if there is a park page for this park
        self.parkCollection.document(self.clickedPark!.placeID!).updateData([:]) { (error) in
            if error != nil{
                self.parkCollection.document(self.clickedPark!.placeID!).setData(["placeID": self.clickedPark!.placeID!, "name": self.clickedPark!.name!, "hasChatRoom" : false])
            }
        }
        self.parkNameLabel.text = marker.snippet
        self.parkPageButton.isEnabled = true
        self.dismissButton.isEnabled = true
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
        if segue.identifier == "goToParkPage" {
            if self.checkedInPark.parkID == nil{
                let nav = segue.destination as! UINavigationController
                let vc = nav.viewControllers[0] as! DogParkViewController
                vc.thisParkID = self.clickedPark!.placeID!
                vc.parkName = self.clickedPark!.name!
            }
            else {
                let nav = segue.destination as! UINavigationController
                let vc = nav.viewControllers[0] as! DogParkViewController
                vc.thisParkID = self.checkedInPark.parkID
                vc.parkName = self.clickedPark?.name!
            }
        }

    }
    func checkIfCheckedIn() { ///This is not working
        self.dogCollection.document(signedInDog.documentID!).getDocument { (DocSnapshot, Error) in
            if DocSnapshot != nil{
                //check if this dog is checked in
                let checkInParkID = DocSnapshot!.data()!["checkedInParkID"] as! String
                if checkInParkID == "0" {
                    return
                }
                else{
                    self.checkedInPark.parkReference = self.parkCollection.document(checkInParkID)
                    self.checkedInPark.parkID = checkInParkID
                    self.checkedInPark.parkReference?.getDocument(completion: { (snapshot2, error2) in
                        if snapshot2 != nil{
                            self.checkedInParkName = snapshot2!.data()!["name"] as! String
                            self.clickedPark = self.list_of_parks[self.checkedInParkName!]
                            DispatchQueue.main.async {
                                //go to the park's page view controller. map is inaccessible while checked in.
                                self.performSegue(withIdentifier: "goToParkPage", sender: self)
                            }
                        }
                    })

                }
            }
        }
    }
}


