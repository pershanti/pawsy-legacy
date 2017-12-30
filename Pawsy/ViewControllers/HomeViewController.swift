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
import CoreLocation
import Cloudinary
import ChameleonFramework


class HomeViewController: UIViewController, OnboardingViewControllerDelegate {
    
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
    var userDoc: DocumentReference?
    var authUI: FUIAuth?
    var currentLocation: CLLocation?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOnboarding" {
            let destination = segue.destination as! UINavigationController
            let final = destination.childViewControllers[0] as! OnboardingViewController
            final.delegate = self
        }
    }
    
    func addLocationToUserDoc(){
        self.user = Auth.auth().currentUser
        self.userDoc = Firestore.firestore().collection("users").document(self.user!.uid)
        if currentLocation != nil{
            userDoc?.updateData(["latitude": currentLocation?.coordinate.latitude as Any])
            userDoc?.updateData(["longitude": currentLocation?.coordinate.longitude as Any])
        }
        
    }
    
    func showOnboardButton(){
        self.addNewButton.isHidden = false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLocationToUserDoc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
