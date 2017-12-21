//
//  OnBoardingViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/21/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit

protocol OnboardingViewControllerDelegate: class {
    func didPressCancel(_ controller: OnboardingViewController)
    func didFinishOnboarding(_ controller: OnboardingViewController, data: DataModel)
}


