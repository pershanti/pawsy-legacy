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
import ChatSDK

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
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
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "goToLaunchAfterSignOut", sender: self)
        currentDog.sharedInstance.currentReference = nil
        NM.auth().logout()
    }
    
    @IBAction func switchDogs(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "selectDogFromHome", sender: self)
    }

    
    
    override func viewDidLoad() {
        currentDog.sharedInstance.currentReference!.getDocument(completion: { (snapshot, error) in
            if snapshot != nil{
                let name = snapshot?.data()!["name"] as? String
                DispatchQueue.main.async {
                    self.nameLabel.text = name
                }
            }
        })
        print(currentDog.sharedInstance.currentReference?.documentID)
    }
}


