//
//  SavingViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/29/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Cloudinary
import Lottie

protocol SavingViewControllerDelegate: class {
    func allDone(_ controller: SavingViewController)
}
