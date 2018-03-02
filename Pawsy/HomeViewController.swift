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
    
    var currentDog: DocumentReference?
    var currentUser: User?
    
    
    @IBAction func newFriends(_ sender: UIButton) {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "friends0") as! NearbyTableViewController
        
        newVC.currentDog = self.currentDog
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func parkButton(_ sender: UIButton) {
        let newVC = storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
        if self.currentDog != nil{
            newVC.currentDog = self.currentDog
        }
        
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func inboxButton(_ sender: UIButton) {
    }
    @IBAction func friendsButton(_ sender: UIButton) {
    }
    @IBAction func profileButton(_ sender: UIButton) {
    }
    @IBAction func logoutButton(_ sender: UIButton) {
    }
    
    
    
    override func viewDidLoad() {
        
        self.currentUser = Auth.auth().currentUser
        if currentDog == nil{
        var dogID: String = ""
   //sets the current dog as the first one on the user's dog list
            Firestore.firestore().collection("users").document(currentUser!.uid).collection("dogs").getDocuments(completion: { (snapshot, error) in
                if snapshot!.count > 0{
                    dogID = snapshot!.documents[0].documentID
                    self.currentDog = Firestore.firestore().collection("dogs").document(dogID)
                    print(self.currentDog?.documentID)
                }
            })
        }
    }
    
    
    
    
    
}
