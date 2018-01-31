//
//  GetLocation.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie

class GetLocation: UIViewController {

    @IBOutlet weak var lottieLocation: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animationView = LOTAnimationView(name: "location")
        animationView.center = self.lottieLocation.center
        animationView.loopAnimation = true
        self.lottieLocation.addSubview(animationView)
        animationView.play()
    }
    

    

}
