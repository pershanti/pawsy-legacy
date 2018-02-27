//
//  MapViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/19/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase


class MapViewController: UIViewController {
    var dogs = [DocumentSnapshot]()
    var coordinates = [CLLocationCoordinate2D]()
   
    @IBAction func checkInButton(_ sender: Any) {
    }
    override func loadView() {
        navigationItem.title = "Hello Map"
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                              longitude: 151.2086,
                                              zoom: 14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)

        self.view = mapView
        
        
        mapView.settings.zoomGestures = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        
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
                        marker.map = mapView
                    }
                }
            }
        }
       
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
