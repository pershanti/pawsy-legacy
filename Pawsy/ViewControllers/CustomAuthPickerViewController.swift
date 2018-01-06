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
        let image = UIImage(named: "spotLaunchScreen")
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.frame = CGRect(origin: view.frame.origin, size: view.frame.size)
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
