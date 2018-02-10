//
//  CreateUserProfile.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/6/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Cloudinary
import CoreLocation

class SaveUserData: UIViewController {
    var user: LocalUser?
    var fireBaseUser: User?
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var userDoc: DocumentReference?
    var dogDoc: DocumentReference?
    var dogCollection: CollectionReference?
    var userCollection: CollectionReference?
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUser()
        location = self.locationManager.location
        if location != nil{
            self.user!.latitude = (location?.coordinate.latitude)!
            self.user!.longitude = (location?.coordinate.longitude)!
        }
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        self.uploadToCloudinary(photo: self.user!.photo!)
    }
    
    func getFirebaseUser(){
        self.fireBaseUser = Auth.auth().currentUser
        userCollection = Firestore.firestore().collection("users")
        userDoc = userCollection!.document(fireBaseUser!.uid)
        dogCollection = Firestore.firestore().collection("dogs")
        let keys = Array(user!.entity.attributesByName.keys)
        let dict = user!.dictionaryWithValues(forKeys: keys)
        print (dict)
        dogDoc = dogCollection!.addDocument(data: dict)
        userDoc?.collection("dogs").addDocument(data: ["dogID": dogDoc!.documentID], completion: { (error) in
            print("upload started")
            if error != nil{
                print("error in upload")
            }
            else{
                print("upload successful")
            }
        })
    }
    
    func uploadToCloudinary(photo: Data) {
        
        _ = self.cloudinary?.createUploader().upload(data: photo, uploadPreset: "pawsyDogPic", params: nil, progress: {({ (progress) in
            print(progress)
        })}(), completionHandler: { (result, error) in
            if error != nil{
                print(error!)
            }
            else{
                self.user!.photoURL = String(describing: result?.resultJson["url"]!)
                self.user!.photo = nil
                print (self.user!.photoURL)
                self.getFirebaseUser()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchUser(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "LocalUser")
        
        //3
        do {
            user = (try managedContext.fetch(fetchRequest)[0] as? LocalUser)!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    

}
