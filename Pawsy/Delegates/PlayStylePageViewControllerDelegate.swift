//
//  PlayStylePageViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation

protocol PlayStylePageViewControllerDelegate: class {
    func didGetPlayStyle(_ controller: PlayStylePageViewController, energyLevel: Int, dogFeelings: Int, humanFeelings: Int, roughness: Int, ball: Int, playScene: Int, dogSizePreference: Int, lookingFor: Int)
}

