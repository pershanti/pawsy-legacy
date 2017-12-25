//
//  DataModel.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit

class DataModel {
    
    var data = [
        //onboardingviewcontroller
        "name": nil,
        //statsviewcontroller
        "age": nil,
        "weight": nil,
        "breed": nil,
        
        //imageuploadviewcontroller
        "photo": UIImage(),
        
        //playstyleviewcontroller
        "energyLevel": nil,
        "dogFeelings": nil,
        "humanFeelings": nil,
        "roughness": nil,
        "ball": nil,
        "playScene": nil,
        "dogSizePreference": nil,
        "lookingFor": nil,
        ] as [String : Any?]

    init(name: String) {
        self.data["name"] = name
    }
    
}


