//
//  Singletons.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase


struct CheckIn {
    var checkInTime: Date?
    var checkOutTime: Date?
    var dogID: String?
    init(cin: Date, dog: String) {
        self.checkInTime = cin
        self.dogID = dog
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
    var parkID: String?
    var parkReference: DocumentReference?
    static var sharedInstance = CheckedInPark()
}

