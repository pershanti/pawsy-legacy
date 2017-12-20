//
//  DataModel.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation

class DataModel {
    
    var data = [
        "name": "",
        "age": "",
        "vaccine": "",
        "photoURL": "",
        "breed": "",
        "energy": "",
        "dogFeelings": "",
        "humanFeelings": "",
        "roughness": "",
        "ball": "",
        "playScene": "",
        "dogSizePreference": "",
        "looking for": "",
        ]

    init(name: String) {
        self.data[name] = name
    }
    
}


