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
    var dogCheckInReference: DocumentReference?
    var dogCurrentCheckInsReference: DocumentReference?
    var dogReference =  currentDog.sharedInstance.currentReference
    var db = Firestore.firestore()
    var checkInDocument: DocumentSnapshot?
    var checkedInParkPlaceID: String?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gmsmapView: GMSMapView!


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
        //check if child view controller knows it's checked in

        //create a new check in and add it to a list of park check ins
        if self.checkInReference == nil{
            self.newCheckIn = CheckIn(cin: Date(), place: self.clickedPark.placeID!, dog: currentDogID, name: self.clickedPark.name!)
            self.checkInReference = self.db.collection("allCheckIns").addDocument(data: ["checkInTime" : self.newCheckIn!.checkInTime!, "placeName": self.newCheckIn!.placeName!, "placeID" : self.newCheckIn!.placeID!, "dogID" : self.newCheckIn!.dogID!]){ (error) in

                //add the check in to a list specific to this dog park
                self.dogParkReference = self.db.collection("dogParks").document(self.clickedPark.placeID!)
                self.dogParkReference?.setData(["placeName": self.newCheckIn!.placeName!, "placeID":self.newCheckIn!.placeID!])
                self.dogParkCheckInReference =  self.dogParkReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //add the check in ID to the dog's checkIn collection
                self.dogCheckInReference =  self.dogReference!.collection("checkIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //add the check in ID to the dog's current check ins
                self.dogCurrentCheckInsReference = self.dogReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                }
            }


        else{
            ("check in else initiated")
            //add the check in to a list specific to this dog park
            self.checkInReference!.getDocument(completion: { (snapshot, error) in
                if error != nil{
                    self.checkInDocument = snapshot!
                    self.checkedInParkPlaceID = self.checkInDocument!.data()["placeID"] as! String
                    //set dogParkReference
                    //set dogParkCheckInReference
                    self.dogParkReference = self.db.collection("dogParks").document(self.checkedInParkPlaceID!)
                    self.dogParkReference!.collection("currentCheckIns").whereField("checkInReferenceID", isEqualTo: self.checkInDocument!.documentID).getDocuments(completion: { (snap2, error2) in
                        if snap2!.documents.count > 0 {
                            self.dogParkCheckInReference = snap2!.documents[0].reference
                             ("set dog Park Check in reference")
                            DispatchQueue.main.async {
                                let vc = self.childViewControllers[0] as! MapPopupViewController
                                if vc.checkedIn == false{
                                    vc.checkedIn = true
                                    vc.checkInButton.setTitle("Check Out", for: .normal)
                                }
                            }
                        }

                    })
                }
            })

        }
    }



    func checkOut(){
        self.newCheckIn?.checkOutTime = Date()
        //update the checkIn to add checkOut time
        self.checkInReference?.updateData(["checkOutTime" : self.newCheckIn!.checkOutTime!])
        //add the check in ID to the park's past check in page
        self.dogParkReference!.collection("pastCheckIns").addDocument(data: ["checkInID":self.checkInReference!.documentID])
        //delete references
        self.dogParkCheckInReference!.delete()
        self.dogCurrentCheckInsReference!.delete()
        self.checkInReference = nil
        self.dogParkReference = nil
        self.dogParkCheckInReference = nil
        self.newCheckIn = nil
        self.dogCurrentCheckInsReference = nil
        self.dogCheckInReference = nil
    }

    func checkIfCheckedIn() {
        //set checkInReference
        //set dogCurrentCheckInsReference
        print("checkingIfCheckedIn")
        self.dogReference?.collection("currentCheckIns").getDocuments(completion: { (snap, error) in
            if snap!.documents.count > 0 {
                print("thereIsACurrentCheckIn")
                self.dogCurrentCheckInsReference = snap!.documents[0].reference
                let checkInID = snap!.documents[0].data()["checkInReferenceID"] as! String
                self.checkInReference = self.db.collection("allCheckIns").document(checkInID)
                self.checkIn()
            }
            else{
                print("no current checkIns")
            }
        })
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


