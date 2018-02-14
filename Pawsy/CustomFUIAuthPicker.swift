//
//  CustomFUIAuthPicker.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/13/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import Firebase

class CustomFUIAuthPicker: FUIAuthPickerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.alpha = 0.5
        
        let backView = UIImageView(image: UIImage(named: "bwDog"))
        backView.frame = view.frame
        backView.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(backView)
        self.view.sendSubview(toBack: backView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(authUI: FUIAuth){
        super.init(nibName: nil, bundle: nil, authUI: authUI)
    }
    
    
    
}
