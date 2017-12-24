//
//  PetNameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/14/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Eureka
import ImageRow

class OnboardingViewController: FormViewController {
    
    
    let user = Auth.auth().currentUser!
    var newDog: DataModel?
    var delegate: OnboardingViewControllerDelegate?
   
   
    
    func createForm(){
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
