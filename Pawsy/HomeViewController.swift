//
//  HomeViewController.swift
//  PawsyApp
//
//  Created by Shantini Vyas on 12/12/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI


class HomeViewController: UIViewController, OnboardingViewControllerDelegate {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBAction func addNewPup(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToOnboarding", sender: nil)
    }
    @IBAction func logOutButtonPressed(_ sender: UIButton)  {
        do{
            try self.authUI!.signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch {
            print("error")
        }
    }
    
    var user: User?
    var authUI: FUIAuth?
    var downloadURL: String?
    
    func didFinishOnboarding(_ controller: OnboardingViewController, data: [String: Any?]) {
        var dataUpload = [String: Any]()
        let dogName: String = data["name"] as! String
        let db = Firestore.firestore()
        
        for items in data{
            if items.value == nil{
                dataUpload[items.key] = ""
            }
            else if items.key != "photo" {
                dataUpload[items.key] = items.value
            }
            
        }
        let dogImage = data["photo"] as! UIImage
        let imagedata  = UIImagePNGRepresentation(dogImage)
        let storage = Storage.storage()
        let dogID = self.user!.uid + "-" + dogName
        let newRef = storage.reference().child("images/"+dogID)
        
        _ = newRef.putData(imagedata!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print(error!)
                dataUpload["photo"] = ""
                return
            }
            self.downloadURL = "gs://pawsy-c0063.appspot.com/images/" + dogID
            dataUpload["photo"] = self.downloadURL
            let newDoc = db.collection("users").document(self.user!.uid).collection("dogs").document(dogName)
            newDoc.setData(dataUpload)
            let imageRef = storage.reference(forURL: self.downloadURL!)
            imageRef.getData(maxSize: 1 * 512 * 512) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                }
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOnboarding" {
            let destination = segue.destination as! UINavigationController
            let final = destination.childViewControllers[0] as! OnboardingViewController
            final.delegate = self
        }
    }
    
    func showOnboardButton(){
        self.addNewButton.isHidden = false
    }
    
    func showCurrentDogs(){
    }
    
    func checkIfOnboarded() {
        let db = Firestore.firestore()
        let uid = self.user?.uid
        let docRef = db.collection("users").document(uid!)
        docRef.getDocument { (document, error) in
            if document?.exists == false {
                docRef.setData([
                    "name": self.user?.displayName,
                    "onboarded": false
                    ])
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = Auth.auth().currentUser
        self.profileName?.text = user?.displayName
        self.checkIfOnboarded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
