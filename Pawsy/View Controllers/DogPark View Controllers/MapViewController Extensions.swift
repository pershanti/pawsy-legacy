//
//  Map Extensions.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/20/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import SwiftHTTP
import SwiftyJSON

extension GMSMapView {
    ///these functions calculate a radius in which to search for parks, based on the current map view.
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


extension MapViewController{
    //Makes a request to Google Places API for dog parks within viewable range of the map. Creates markers for each park.

    func getParks(){
        let radius = self.gmsmapView.getRadius()
        let parameters = [
            "key":"AIzaSyBi_wAJjT3NnPaX0gjpmsGE5d0UYhTNAx8",
            "location" : "\(self.gmsmapView.camera.target.latitude), \(self.gmsmapView.camera.target.longitude)",
            "radius" : "\(radius)",
            "keyword" : "dog park",
            ]
        HTTP.GET("https://maps.googleapis.com/maps/api/place/nearbysearch/json", parameters: parameters, headers: nil)
        { (response) in
            if response.error != nil{
                print("error: ", response.error!.localizedDescription)
            }
            else{
                let json = JSON(response.data)
                let count = json["results"].array?.count
                for number in 0...count!{
                    let place = json["results"][number]
                    let placeName = place["name"].string
                    let placeID = place["place_id"].string
                    let lat  = place["geometry"]["location"]["lat"].double
                    let lng  = place["geometry"]["location"]["lng"].double
                    if lat != nil && lng != nil{
                        DispatchQueue.main.async {
                            let coordinate = CLLocationCoordinate2D(latitude: lat!,longitude: lng!)
                            let marker = GMSMarker(position: coordinate)
                            marker.snippet = placeName!
                            marker.map = self.gmsmapView
                            let newPark = Park(placename: placeName!, id: placeID!, coordinate: coordinate)
                            self.list_of_parks[placeName!] = newPark
                        }
                    }
                }
            }
        }
    }
}

extension MapViewController: MapPopupViewControllerDelegate, DogParkViewControllerDelegate {
    func checkIn(){
        let currentDogID = currentDog.sharedInstance.documentID!
        //create a new check in and add it to a list of park check ins
        if self.checkInReference == nil{
            print("checkInReference is Nil")
            self.newCheckIn = CheckIn(cin: Date(), place: self.clickedPark.placeID!, dog: currentDogID, name: self.clickedPark.name!)
            self.checkInReference = self.db.collection("allCheckIns").addDocument(data: ["checkInTime" : self.newCheckIn!.checkInTime!, "placeName": self.newCheckIn!.placeName!, "placeID" : self.newCheckIn!.placeID!, "dogID" : self.newCheckIn!.dogID!]){ (error) in
                print("creating new check ins")
                //add the check in to a list specific to this dog park
                self.dogParkReference = self.db.collection("dogParks").document(self.clickedPark.placeID!)
                self.dogParkReference?.setData(["placeName": self.newCheckIn!.placeName!, "placeID":self.newCheckIn!.placeID!, "hasChatRoom": false])
                self.dogParkCheckInReference =  self.dogParkReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //add the check in ID to the dog's checkIn collection
                self.dogCheckInReference =  self.dogReference!.collection("checkIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //add the check in ID to the dog's current check ins
                self.dogCurrentCheckInsReference = self.dogReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])
                //segue into the park view controller
                self.performSegue(withIdentifier: "goToParkPage", sender: self)
            }
        }
        else{
            //if already checked in, get the details of it and add the check in to a list specific to this dog park
            self.checkInReference!.getDocument(completion: { (snapshot, error) in
                if error == nil{
                    print("got check in document")
                    self.checkInDocument = snapshot!
                    self.checkedInParkPlaceID = self.checkInDocument!.data()!["placeID"] as! String
                    let placeName = self.checkInDocument!.data()!["placeName"] as! String
                    //set dogParkReference
                    //set dogParkCheckInReference
                    self.dogParkReference = self.db.collection("dogParks").document(self.checkedInParkPlaceID!)
                    self.dogParkReference!.collection("currentCheckIns").whereField("checkInReferenceID", isEqualTo: self.checkInDocument!.documentID).getDocuments(completion: { (snap2, error2) in
                        if snap2!.documents.count > 0 {
                            self.dogParkCheckInReference = snap2!.documents[0].reference
                            DispatchQueue.main.async {
                                let vc = self.childViewControllers[0] as! MapPopupViewController
                                if vc.checkedIn == false{
                                    vc.checkedIn = true
                                    vc.checkInButton.setTitle("Check Out", for: .normal)
                                    //segue into the park view controller
                                    self.performSegue(withIdentifier: "goToParkPage", sender: self)
                                }
                            }
                        }
                    })
                }
                else{
                    print(error!.localizedDescription)
                }
            })
        }
    }

    func checkOut(){
        //update the checkIn to add checkOut time
        self.checkInReference?.updateData(["checkOutTime" : Date()])
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
        self.gmsmapView.isUserInteractionEnabled = true
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
                print (checkInID)
                self.checkInReference = self.db.collection("allCheckIns").document(checkInID)
                self.checkIn()

            }
            else{
                print("no current checkIns")
            }
        })
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
