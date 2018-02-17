//
//  CenterViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/31/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import GoogleMaps

class CenterViewController: UIViewController {
    
    var delegate: CenterViewControllerDelegate?

    override func loadView() {
        navigationItem.title = "Hello Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Slide out", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(delegate?.toggleLeftPanel))
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.868,
                                              longitude: 151.2086,
                                              zoom: 14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        view = mapView
    }


}
