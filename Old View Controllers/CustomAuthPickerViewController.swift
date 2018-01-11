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
        let greenView = UIView()
        greenView.clipsToBounds = true
        greenView.backgroundColor = UIColor(named: "NewMint")
        greenView.frame = CGRect(origin: view.frame.origin, size: view.frame.size)
        view.addSubview(greenView)
        view.sendSubview(toBack: greenView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
