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

class MapViewController: UIViewController, GMSMapViewDelegate {

    var dogs = [DocumentSnapshot]()
    var coordinates = [CLLocationCoordinate2D]()
    var checkedIn = false
    var current: DocumentReference?
    var currentUser = Auth.auth().currentUser
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var placeDoc: DocumentReference?
    var zoomLevel: Float = 15.0
    var checkedInReference: DocumentReference?
    var checkInTime: Date?
    let defaultLocation = CLLocation(latitude: 37.332239, longitude: -122.030824)
    

    @IBOutlet weak var gmsmapView: GMSMapView!
    @IBOutlet weak var checkinButtonChange: UIBarButtonItem!
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
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func checkOutOfFirebase(){
        print("checkout function running")
        let checkInDoc = self.current?.collection("check-ins").document()
        self.checkedInReference?.delete()
        self.checkedInReference = nil
    }
    
    func checkInToFirebase(){
        self.checkedInReference = placeDoc!.collection("checkedInUsers").document(self.current!.documentID)
        self.checkedInReference?.setData(["Check-In Time": Date()])
        self.checkInTime = Date()
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    }
    
    
    override func viewDidLoad() {
        self.current = currentDog.sharedInstance.currentReference
        self.getLocation()
    }


    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

    }
    func setUpMap(){
        placesClient = GMSPlacesClient.shared()
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                              longitude: self.currentLocation!.coordinate.longitude,
                                              zoom: 14)
        self.gmsmapView.camera = camera
        gmsmapView.settings.zoomGestures = true
        gmsmapView.settings.myLocationButton = true
        gmsmapView.settings.scrollGestures = true
        gmsmapView.isMyLocationEnabled = true
        self.gmsmapView.clear()
        self.gmsmapView.delegate = self
        self.getParks()
    }

    func getParks(){
        let serializer = JSONParameterSerializer()
        let radius = self.gmsmapView.getRadius()
        let parameters = [
            "key":"AIzaSyBi_wAJjT3NnPaX0gjpmsGE5d0UYhTNAx8",
            "location" : "\(self.currentLocation!.coordinate.latitude), \(self.currentLocation!.coordinate.longitude)",
            "radius" : "\(radius)",
            "keyword" : "dog park",
            ]
        HTTP.GET("https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters: parameters, headers: nil) { (response) in
            if response.error != nil{
                print("error: ", response.error!.localizedDescription)
                return
            }
            else{
                do{
                    let json = try JSONSerialization.jsonObject(with: response.data) as? [String: NSArray]
                    for place in json!["results"]! {
                        

                        let newMarker = GMSMarker(position)
                    }
                }
                catch{
                    print("couldnt deserialize json")
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }

    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }

    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
    }
}



extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        print("Location: \(self.currentLocation)")
        
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                              longitude: self.currentLocation!.coordinate.longitude,
                                              zoom: zoomLevel)
        gmsmapView.animate(to: camera)
         self.setUpMap()
    }
}


