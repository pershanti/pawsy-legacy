//
//  Singletons.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import Foundation
import CoreLocation


struct CheckIn {
    var checkInTime: Date?
    var checkOutTime: Date?
    var placeID: String?
    var placeName: String?
    var dogID: String?
    init(cin: Date, place: String, dog: String, name: String) {
        self.checkInTime = cin
        self.placeID = place
        self.dogID = dog
        self.placeName = name
    }
}

class Park {
    var name: String?
    var placeID: String?
    var hasChatRoom: Bool = false
    init(placename: String, id: String) {
        self.name = placename
        self.placeID = id
    }
    init(){

    }
}

class CheckedInPark {
    var park: Park = Park()
    static var sharedInstance = CheckedInPark()
}

