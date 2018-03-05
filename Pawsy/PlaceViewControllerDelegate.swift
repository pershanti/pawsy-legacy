//
//  PlaceViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 3/5/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import GooglePlaces


protocol PlaceViewControllerDelegate {

    func setSelectedPlace(place: GMSPlace)

}
