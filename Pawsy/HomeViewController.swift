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
    
    @IBOutlet weak var dogHomeImageView: UIImageView!
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
