//
//  LaunchScreenViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/1/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import ChameleonFramework
import NVActivityIndicatorView



class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: (view.frame.width-200)/2, y: (view.frame.height-200)/2, width: 200, height: 200)
        let animationView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballSpinFadeLoader, color: FlatWhite(), padding: nil)
        view.addSubview(animationView)
        animationView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
