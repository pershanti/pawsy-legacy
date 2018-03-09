//
//  LaunchViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//


import UIKit
import CoreData
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
        FUIFacebookAuth(),

    ]
    var userDoc: DocumentReference?
    
    @IBAction func signUpButton(_ sender: UIButton) {
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = self.providers
        
        let authViewController = authUI!.authViewController()
        authViewController.delegate = self
        present(authViewController, animated: true, completion: nil)
    }
    
    func checkIfOnboarded() {
        let db = Firestore.firestore()
        let uid = self.user?.uid
        self.userDoc = db.collection("users").document(uid!)
        let dogCollection = self.userDoc?.collection("dogs")
        self.userDoc!.getDocument { (document, error) in
            if document?.exists == false {
                self.userDoc!.setData([
                    "name": self.user?.displayName as Any,
                    ])
                self.performSegue(withIdentifier: "goToIntro", sender: nil)
                
            }
            else {
                dogCollection?.getDocuments(completion: { (snap, err) in
                    //if user has not added a dog, go to onboarding
                    if snap!.documents.count == 0 {
                        self.performSegue(withIdentifier: "goToIntro", sender: nil)
                    }
                        //if user has more than one dog, go to selectDog screen
                    else if snap!.documents.count > 1 {
                        self.performSegue(withIdentifier: "selectDog", sender: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "loggedInHome", sender: nil)
                    }
                })
            }
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil{
            print(error.debugDescription)
        }
        self.user = Auth.auth().currentUser
        self.checkIfOnboarded()
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

class currentDog{
    static let sharedInstance = currentDog()
    var currentReference: DocumentReference?
    private init(){
        
    }
}
