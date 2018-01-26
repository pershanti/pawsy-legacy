//
//  AuthViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/28/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class CustomAuthPickerViewController: FUIAuthPickerViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(authUI: FUIAuth){
        super.init(nibName: nil, bundle: nil, authUI: authUI)
        let backView = UIImageView(image: UIImage(named: "blue gradient"))
        backView.frame.size = view.frame.size
        backView.clipsToBounds = true
        view.addSubview(backView)
        view.sendSubview(toBack: backView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
