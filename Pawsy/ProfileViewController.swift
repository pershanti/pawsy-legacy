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
    
    @IBOutlet weak var addFriendButton: UIBarButtonItem!
    
    @IBAction func addFriend(_ sender: Any) {
      
    }
    
    func setLabels(){
        self.profileName.text = self.dog?.data()["name"] as? String
        self.breed.text = self.dog?.data()["breed"] as? String
        
        if let string = self.dog?.data()["weight"] as? NSString {
            self.weight.text = self.dog?.data()["weight"] as! String + " lbs."
        }
        else{
            self.weight.text = (self.dog?.data()["weight"] as! NSNumber).stringValue + " lbs."
        }
        self.gender.text = self.dog?.data()["gender"] as? String
        if self.dog?.data()["fixed"] as? String == "Yes"{
            self.fixed.text = "Fixed"
        }
        else{
            self.fixed.text = "Not Fixed"
        }
        let photoURL = self.dog?.data()["photo"] as! String
        
        self.cloudinary?.createDownloader().fetchImage(photoURL, nil, completionHandler: { (image, error) in
            if error != nil {
                print(error!.description)
            }
            if image != nil{
                DispatchQueue.main.async {
                    self.profilePhoto.image = image
                }
            }
        })
    
        let date = self.dog?.data()["birthdate"] as? Date
            let components = Calendar.current.dateComponents([.year, .month], from: date!, to: Date())
            if components.year! < 1{
                self.age.text = String(describing: components.month!) + " months old"
            }
            else if components.year! < 2 {
                if components.month! < 2{
                    self.age.text = String(describing: components.year!) + " year, " + String(describing: components.month!) + " month old"
                }
                else{
                    self.age.text = String(describing: components.year!) + " year, " + String(describing: components.month!) + " months old"
                }
            }
            else if components.year! > 2{
                if components.month! < 2{
                    self.age.text = String(describing: components.year!) + " years, " + String(describing: components.month!) + " month old"
                }
                else{
                    self.age.text = String(describing: components.year!) + " years, " + String(describing: components.month!) + " months old"
                }
            }
        }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary  = CLDCloudinary(configuration: self.config!)
        if self.dog == nil{
            currentDog.sharedInstance.currentReference?.getDocument(completion: { (snapshot, error) in
                if snapshot != nil{
                    self.dog = snapshot
                    DispatchQueue.main.async {
                        self.setLabels()
                    }
                }
            })
        }
        else{
            self.setLabels()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
