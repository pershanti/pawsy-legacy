//
//  LaunchViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/30/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI



class LaunchViewController: UIViewController, FUIAuthDelegate, UINavigationControllerDelegate {
    
    var window: UIWindow?
    var authUI: FUIAuth?
    var user: User?
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth()
    ]
    var userDoc: DocumentReference?

    @IBAction func signUpButton(_ sender: UIButton) {
        self.goToOnboarding()
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = self.providers
        
        let authViewController = authUI!.authViewController()
        authViewController.delegate = self
        present(authViewController, animated: false, completion: nil)
        print("here")
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        print(error.debugDescription)
        self.user = Auth.auth().currentUser
        self.checkIfOnboarded()
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func checkIfOnboarded() {
        let db = Firestore.firestore()
        let uid = self.user?.uid
        self.userDoc = db.collection("users").document(uid!)
        self.userDoc!.getDocument { (document, error) in
            if document?.exists == false {
                self.userDoc!.setData([
                    "name": self.user?.displayName as Any,
                    ])
                self.goToOnboarding()
            }
            else {
                self.goToHome()
            }
        }
    }
    
    func goToHome(){
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func goToOnboarding(){
        performSegue(withIdentifier: "goToWalkthrough", sender: self)
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CustomAuthPickerViewController(authUI: self.authUI!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
