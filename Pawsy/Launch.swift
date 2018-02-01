//
//  Launch.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/31/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class Launch: UIViewController, FUIAuthDelegate, UINavigationControllerDelegate {
    
    var window: UIWindow?
    var authUI: FUIAuth?
    var user: User?
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth()
    ]
    var userDoc: DocumentReference?
    
    @IBAction func signUpButton(_ sender: UIButton) {
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = self.providers
        
        let authViewController = authUI!.authViewController()
        authViewController.delegate = self
        present(authViewController, animated: false, completion: nil)
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
                self.performSegue(withIdentifier: "toOnboarding", sender: self)
            }
            else {
                self.performSegue(withIdentifier: "goToHomeFromLogin", sender: self)
            }
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil{
            print(error.debugDescription)
        }
        self.user = Auth.auth().currentUser
        performSegue(withIdentifier: "toOnboarding", sender: self)
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CustomFUIAuthPicker(authUI: self.authUI!)
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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
}
