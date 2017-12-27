//
//  FormViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/24/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol OnboardingViewControllerDelegate: class {
    func uploadToCloudinary(_controller: OnboardingViewController, photo: UIImage, dogID: String, document: DocumentReference)
}

