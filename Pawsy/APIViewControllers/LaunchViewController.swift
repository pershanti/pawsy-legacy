//
//  LaunchViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/30/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookLogin
import AWSMobileClient
import AWSAuthCore
import AWSAuthUI


class LaunchViewController: UIViewController, UINavigationControllerDelegate {
    
    var window: UIWindow?
    var location: CLLocation?
    var locationDenied: Bool?

    @IBAction func signUpButton(_ sender: UIButton) {
        
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        func viewDidLoad() {
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            
            view.addSubview(loginButton)
        }
    }

    
    func goToHome(){
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func goToOnboarding(){
        performSegue(withIdentifier: "goToWalkthrough", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
