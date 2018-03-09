//
//  HomeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/21/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class HomeViewController: UIViewController {
    
    @IBAction func newFriends(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToNearby", sender: self)
    }
    
    @IBAction func parkButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    @IBAction func inboxButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToInbox", sender: self)
    }
    @IBAction func friendsButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToFriends", sender: self)
    }
    
    @IBAction func profileButton(_ sender: UIButton) {
        let profileVC = storyboard!.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        profileVC.currentDog = currentDog.sharedInstance.currentReference
        self.present(profileVC, animated: true, completion: nil)
    }
    @IBAction func logoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "goToLaunchAfterSignOut", sender: self)
        currentDog.sharedInstance.currentReference = nil
    }
    
    @IBAction func switchDogs(_ sender: UIButton) {
        self.performSegue(withIdentifier: "selectDogFromHome", sender: self)
    }
    
    
    override func viewDidLoad() {
        print(currentDog.sharedInstance.currentReference?.documentID)
    }
}


