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



class MapViewController: UIViewController {
    var dogs = [DocumentSnapshot]()
    var coordinates = [CLLocationCoordinate2D]()
    var checkedIn = false
    var currentDog: DocumentReference?
    var currentUser = Auth.auth().currentUser
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let defaultLocation = CLLocation(latitude: 37.332239, longitude: -122.030824)
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?

    @IBOutlet weak var gmsmapView: GMSMapView!
    @IBOutlet weak var checkinButtonChange: UIBarButtonItem!
    @IBAction func checkInButton(_ sender: Any) {
        if self.checkedIn == false{
            self.checkedIn = true
            print("checkedIn")
            self.checkinButtonChange.title = "Check Out"
            self.performSegue(withIdentifier: "segueToSelect", sender: self)
        }
        else{
            self.checkedIn = true
            print("checkedOut")
            self.checkinButtonChange.title = "Check In"
        }
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        navigationItem.title = "Pawsy"
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()

        let camera = GMSCameraPosition.camera(withLatitude: self.defaultLocation.coordinate.latitude,
                                             longitude: self.defaultLocation.coordinate.longitude,
                                             zoom: 14)
        self.gmsmapView.camera = camera
        gmsmapView.settings.zoomGestures = true
        gmsmapView.settings.myLocationButton = true
        gmsmapView.settings.scrollGestures = true
        gmsmapView.isMyLocationEnabled = true
        self.gmsmapView.clear()
        if selectedPlace != nil {
            let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
            marker.title = selectedPlace?.name
            marker.snippet = selectedPlace?.formattedAddress
            marker.map = self.gmsmapView
        }
        
        listLikelyPlaces()
        
        let db = Firestore.firestore().collection("dogs")
        db.getDocuments { (snapshot, error) in
            if error == nil {
                if snapshot!.documents.count != 0{
                    self.dogs = snapshot!.documents
                    for doc in self.dogs{
                        let latitude = doc.data()["latitude"] as! NSNumber
                        let longitude = doc.data()["longitude"] as! NSNumber
                        let coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
                        let marker = GMSMarker()
                        marker.position = coordinate
                        marker.snippet = doc.data()["name"] as? String
                        marker.appearAnimation = GMSMarkerAnimation.pop
                        marker.map = self.gmsmapView
                    }
                }
            }
        }
      
        
        
    }

    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelect" {
            if let nextViewController = segue.destination as? PlacesViewController {
                nextViewController.likelyPlaces = likelyPlaces
            }
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        print("Location: \(self.currentLocation)")
        
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                              longitude: self.currentLocation!.coordinate.longitude,
                                              zoom: zoomLevel)
        gmsmapView.animate(to: camera)
        self.listLikelyPlaces()
    }
}
