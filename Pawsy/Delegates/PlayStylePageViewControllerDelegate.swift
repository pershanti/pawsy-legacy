//
//  PlayStylePageViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit

protocol PlayStylePageViewControllerDelegate: UIPageViewControllerDelegate{
    func didGetPlayStyle(_ controller: PlayStylePageViewController, energyLevel: String, dogFeelings: String, humanFeelings: String, roughness: String, ball: String, playScene: String, dogSizePreference: String, lookingFor: String)
}

