//
//  ProfileViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/19/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class ProfileViewController: UIViewController {
    
    var dog: DocumentSnapshot?
    var photo: UIImage?
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
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
      
    }
    
    @IBOutlet weak var message: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary  = CLDCloudinary(configuration: self.config!)
        if self.dog == nil{
            currentDog.sharedInstance.currentReference?.getDocument(completion: { (snapshot, error) in
                if snapshot != nil{
                    self.dog = snapshot
                }
            })
        }
        
        self.profileName.text = dog?.data()["name"] as? String
        self.breed.text = dog?.data()["breed"] as? String
        self.weight.text = dog?.data()["weight"] as? String
        self.gender.text = dog?.data()["gender"] as? String
        self.fixed.text = dog?.data()["fixed"] as? String
        let photoURL = dog?.data()["photo"] as? String
        self.cloudinary?.createDownloader().fetchImage(photoURL!, nil, completionHandler: { (image, error) in
            if error != nil {
                print("error")
            }
            if image != nil{
                DispatchQueue.main.async {
                    self.profilePhoto.image = image
                }
            }
        })
//        let date = dog?.data()["birthdate"] as! Date
//        let age = date.timeIntervalSinceNow

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
