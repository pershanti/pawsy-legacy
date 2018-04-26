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

    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    

    @IBOutlet weak var dogLabel: UILabel!

    @IBOutlet weak var profPhoto: UIImageView!
    
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
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        self.profPhoto.clipsToBounds = true
        self.profPhoto.layer.cornerRadius = self.profPhoto.frame.size.width/2
        currentDog.sharedInstance.currentReference!.getDocument(completion: { (snapshot, error) in
            if snapshot != nil{
                let name = snapshot?.data()!["name"] as? String
                let photoURL = snapshot?.data()!["photo"] as? String
                DispatchQueue.main.async {
                    self.dogLabel.text = name! + "!"
            }

                self.cloudinary?.createDownloader().fetchImage(photoURL!, nil, completionHandler: { (image, error) in
                    if error != nil {
                        print(error!.description)
                    }
                    if image != nil{
                        DispatchQueue.main.async {
                            self.profPhoto.image = image
                        }
                    }
                })
            }
        })
        print(currentDog.sharedInstance.currentReference?.documentID)
    }
}


