//
//  AuthViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/28/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import FirebaseAuthUI

func authPickerViewController(for authUI: FUIAuth) -> FUIAuthPickerViewController {
    return CustomAuthPickerViewController(authUI: authUI)
}
