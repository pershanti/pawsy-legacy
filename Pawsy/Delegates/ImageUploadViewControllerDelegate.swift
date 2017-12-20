//
//  ImageUploadViewControllerDelegate.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//
import Foundation
import UIKit

protocol ImageUploadViewControllerDelegate: class {
    
    func didGetPhoto(_ controller: ImageUploadViewController, imagePath: URL)
}
