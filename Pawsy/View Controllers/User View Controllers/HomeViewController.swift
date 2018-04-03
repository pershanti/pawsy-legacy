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
import SendBirdSDK

class HomeViewController: UIViewController {
    
    @IBAction func parkButton(_ sender: UIButton) {

        self.performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    @IBAction func profileButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        currentDog.sharedInstance.currentReference = nil
        currentDog.sharedInstance.imageURL = nil
        currentDog.sharedInstance.image = nil
        currentDog.sharedInstance.name = nil
        currentDog.sharedInstance.documentID = nil
        self.performSegue(withIdentifier: "goToLaunchAfterSignOut", sender: self)
    }
    
    @IBAction func switchDogs(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "selectDogFromHome", sender: self)
    }

    func signIntoChat(){

    }


    
    override func viewDidLoad() {
        currentDog.sharedInstance.currentReference!.getDocument(completion: { (snapshot, error) in
            if snapshot != nil{
                let name = snapshot?.data()!["name"] as? String
                DispatchQueue.main.async {
                    self.navigationItem.title = name!
                }
            }
        })
        print(currentDog.sharedInstance.currentReference?.documentID)
    }
}


