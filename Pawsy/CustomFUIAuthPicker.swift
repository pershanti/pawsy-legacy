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
import Lottie

class CustomFUIAuthPicker: FUIAuthPickerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.alpha = 0.5
        
        let backView = UIImageView(image: UIImage(named: "gradient only"))
        backView.frame = view.frame
        backView.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(backView)
        self.view.sendSubview(toBack: backView)
        let animationView = LOTAnimationView(name: "floating_cloud")
        animationView.frame = CGRect(x: view.center.x-125, y: view.center.y-125, width: 250, height: 250)
        view.contentMode = UIViewContentMode.scaleAspectFit
        animationView.loopAnimation = true
        self.view.addSubview(animationView)
        animationView.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(authUI: FUIAuth){
        super.init(nibName: nil, bundle: nil, authUI: authUI)
    }
    
 

}
