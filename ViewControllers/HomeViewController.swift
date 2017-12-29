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
import Cloudinary


class HomeViewController: UIViewController, OnboardingViewControllerDelegate {
    
    @IBOutlet weak var dogHomeImageView: UIImageView!
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
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    
    func didFinishOnboarding(_ controller: OnboardingViewController, photo: UIImage) {
        self.dogHomeImageView.image = photo
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
    
    func uploadToCloudinary(_controller: OnboardingViewController, photo: UIImage, dogID: String, document: DocumentReference) {
        let uploadData = UIImageJPEGRepresentation(photo, 1)
       
        let upload = self.cloudinary?.createUploader().upload(data: uploadData!, uploadPreset: "pawsyDogPic").response({
            (result, error) in
            print (result?.tags)
            let downloadURL = result?.publicId
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = Auth.auth().currentUser
        self.checkIfOnboarded()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
