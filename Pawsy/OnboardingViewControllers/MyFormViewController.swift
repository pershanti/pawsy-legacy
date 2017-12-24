//
//  MyFormViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/24/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import ImageRow

class MyFormViewController: FormViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Basic Info")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "name"
            }
            <<< TextRow(){ row in
                row.title = "Age"
                row.placeholder = "years"
            }
            <<< TextRow(){ row in
                row.title = "weight"
                row.placeholder = "lbs"
            }
            +++ Section("Photo")
            <<< ImageRow(){ row in
                row.title = "Puppy Paw-trait"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
            }
    }
}
