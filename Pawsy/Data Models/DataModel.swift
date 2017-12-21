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
        //onboardingviewcontroller
        "name": "",
        //statsviewcontroller
        "age": nil,
        "vaccine": nil,
        "breed": "",
        
        //imageuploadviewcontroller
        "photoURL": "",
        
        //playstyleviewcontroller
        "energyLevel": nil,
        "dogFeelings": nil,
        "humanFeelings": nil,
        "roughness": nil,
        "ball": nil,
        "playScene": nil,
        "dogSizePreference": nil,
        "looking for": nil,
        ]

    init(name: String) {
        self.data[name] = name
    }
    
}


