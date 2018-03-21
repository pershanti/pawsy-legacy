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
                return
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
