//
//  OnboardingDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit

protocol StatsViewControllerDelegate: class {
    func didSubmitStats(_ controller: StatsViewController, age: Int, vaccine: Bool, breed: String )
}

