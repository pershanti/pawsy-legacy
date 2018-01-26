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


class LaunchViewController: UIViewController, UINavigationControllerDelegate, LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        self.goToHome()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    
    var window: UIWindow?
    var location: CLLocation?
    var locationDenied: Bool?
    
    @IBAction func skipLogin(_ sender: UIButton) {
        self.goToOnboarding()
    }
    
    func goToHome(){
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func goToOnboarding(){
        performSegue(withIdentifier: "goToWalkthrough", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.delegate = self
//        loginButton.center.x = view.center.x
//        loginButton.center.y = view.center.y + 300
//        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
