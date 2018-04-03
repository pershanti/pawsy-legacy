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
    

    @IBOutlet weak var dogLabel: UILabel!


    @IBAction func logoutButton(_ sender: UIButton) {
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
    
    @IBAction func switchDogs(_ sender: UIButton) {
        self.performSegue(withIdentifier: "selectDogFromHome", sender: self)
    }

    override func viewDidLoad() {
        currentDog.sharedInstance.currentReference!.getDocument(completion: { (snapshot, error) in
            if snapshot != nil{
                let name = snapshot?.data()!["name"] as? String
                DispatchQueue.main.async {
                    self.dogLabel.text = name! + "!"
                }
            }
        })
        print(currentDog.sharedInstance.currentReference?.documentID)
    }
}


