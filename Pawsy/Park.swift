//
//  Park.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/20/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import Foundation
import CoreLocation



class Park {
    var name: String?
    var placeID: String?
    var coordinates: CLLocationCoordinate2D?
    init(placename: String, id: String, coordinate: CLLocationCoordinate2D) {
        self.name = placename
        self.placeID = id
        self.coordinates = coordinate
    }
}
