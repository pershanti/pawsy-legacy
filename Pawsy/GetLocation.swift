//
//  GetLocation.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie
import CoreLocation

class GetLocation: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager = CLLocationManager()

    @IBOutlet weak var lottieLocation: UIView!
    
    @IBAction func nextButton(_ sender: UIButton) {
        if manager.location == nil{
            manager.requestAlwaysAuthorization()
        }
        else{
            performSegue(withIdentifier: "goToName", sender: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        performSegue(withIdentifier: "goToName", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
