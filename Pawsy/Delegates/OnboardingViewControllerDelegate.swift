//
//  FormViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/24/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation


protocol OnboardingViewControllerDelegate: class {
    func didFinishOnboarding(_ controller: OnboardingViewController, data: [String: Any?])
}

