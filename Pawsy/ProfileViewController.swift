//
//  ProfileViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/19/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var dog: DocumentSnapshot?
    var photo: UIImage?
    var currentDog: DocumentReference?
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var fixed: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBAction func addFriend(_ sender: Any) {
        if self.currentDog != nil{
            let newFriendID = self.dog?.documentID
            //send friend request
        }
    }
    
    @IBOutlet weak var message: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePhoto.image = self.photo!
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width/2
        self.profilePhoto.layer.masksToBounds = true
        self.profileName.text = dog?.data()["name"] as? String
        self.breed.text = dog?.data()["breed"] as? String
        self.weight.text = dog?.data()["weight"] as? String
        self.gender.text = dog?.data()["gender"] as? String
        self.fixed.text = dog?.data()["fixed"] as? String
//        let date = dog?.data()["birthdate"] as! Date
//        let age = date.timeIntervalSinceNow

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
