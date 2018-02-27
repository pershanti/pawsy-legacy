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
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var dogName1: UILabel!
    @IBOutlet weak var dogBreed1: UILabel!
    @IBAction func select1(_ sender: Any) {
        if self.listOfDogIDs.count > 0{
            currentDog.sharedInstance.dogID = self.listOfDogIDs[0]
        }
        
    }
    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var dogName2: UILabel!
    @IBOutlet weak var dogBreed2: UILabel!
    @IBOutlet weak var select2: UIButton!
    @IBAction func selectButton2(_ sender: Any) {
        if self.listOfDogIDs.count > 1 {
            currentDog.sharedInstance.dogID = self.listOfDogIDs[1]
        }
    }
    
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var dogName3: UILabel!
    @IBOutlet weak var dogBreed3: UILabel!
    @IBOutlet weak var select3: UIButton!
    @IBAction func selectButton3(_ sender: Any) {
        if self.listOfDogIDs.count > 2 {
            currentDog.sharedInstance.dogID = self.listOfDogIDs[2]
        }
    }
    

    var listOfDogIDs = [String]()
    var dogs = [DocumentSnapshot]()
    let db = Firestore.firestore()
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    var downloadImage1: UIImage?
    var downloadImage2: UIImage?
    var downloadImage3: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getDogIDs()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
    }
    
    func getDogIDs(){
        let currentUser = Auth.auth().currentUser?.uid
        db.collection("users").document(currentUser!).collection("dogs").getDocuments { (snapshot, error) in
            if error != nil{
                print(error.debugDescription)
            }
            else if snapshot != nil{
                for doc in snapshot!.documents{
                    self.listOfDogIDs.append(doc.data()["dogID"] as! String)
                    print(self.listOfDogIDs)
                    self.showDogs()
                }
            }
        }
    }
    
    
    
    func showDogs(){
        let dog1ID = listOfDogIDs[0]
        let docRef = db.collection("dogs").document(dog1ID)
        docRef.getDocument { (document, error) in
            if let document = document {
                self.dogName1.text = document.data()["name"] as? String
                self.dogBreed1.text = document.data()["breed"] as? String
                let imageURL = document.data()["photo"] as! String
                self.cloudinary?.createDownloader().fetchImage(imageURL, { (progress) in
                    print(progress.fractionCompleted)
                }, completionHandler: { (image, error) in

                    if error != nil{
                        print(error!.description)
                    }
                    if image != nil{
                        self.downloadImage1 = image!
                    }
                    DispatchQueue.main.async {
                        self.image1.image = self.downloadImage1
                        self.image1.isHidden = false
                    }
                })
                

            } else {
                print("Document does not exist")
            }
            

        }
        
        
        if self.listOfDogIDs.count >= 2 {
            let dog2ID = listOfDogIDs[1]
            let docRef = db.collection("dogs").document(dog2ID)
            docRef.getDocument { (document, error) in
                if let document = document {
                    self.dogName2.text = document.data()["name"] as? String
                    self.dogBreed2.text = document.data()["breed"] as? String
                    let imageURL = document.data()["photo"] as! String
                    self.cloudinary?.createDownloader().fetchImage(imageURL, nil, completionHandler: { (image, error) in
                        if error != nil{
                            print(error!.description)
                        }
                        if image != nil{
                            self.downloadImage2 = image!
                        }
                    })
                    self.dogName2.isHidden = false
                    self.dogBreed2.isHidden = false
                    self.image2.isHidden = false
                    self.select2.isHidden = false
                    self.select2.isEnabled = true
                } else {
                    print("Document does not exist")
                }
            }
            if self.downloadImage2 != nil{
                self.image2.image = self.downloadImage2
            }
        }
        
        if listOfDogIDs.count >= 3{
            let dog3ID = listOfDogIDs[2]
            let docRef = db.collection("dogs").document(dog3ID)
            docRef.getDocument { (document, error) in
                if let document = document {
                    self.dogName3.text = document.data()["name"] as? String
                    self.dogBreed3.text = document.data()["breed"] as? String
                    let imageURL = document.data()["photo"] as! String
                    self.cloudinary?.createDownloader().fetchImage(imageURL, nil, completionHandler: { (image, error) in
                        if error != nil{
                            print(error!.description)
                        }
                        if image != nil{
                            self.downloadImage3 = image!
                        }
                    })
                    self.dogName3.isHidden = false
                    self.dogBreed3.isHidden = false
                    self.image3.isHidden = false
                    self.select3.isHidden = false
                    self.select3.isEnabled = true
                } else {
                    print("Document does not exist")
                }
            }
            if self.downloadImage3 != nil{
                self.image3.image = self.downloadImage3
            }
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

class currentDog{
    static let sharedInstance = currentDog()
    var dogID: String?
    
    private init(){
    }
}
