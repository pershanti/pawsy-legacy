//
//  CustomFUIAuthPicker.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/31/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import Firebase

class CustomFUIAuthPicker: FUIAuthPickerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        var backView = UIImageView(image: UIImage(named: "pawsy heart blue")!)
        backView.frame = self.view.frame
        self.view.addSubview(backView)
        view.sendSubview(toBack: backView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(authUI: FUIAuth){
        super.init(nibName: nil, bundle: nil, authUI: authUI)
    }

}
