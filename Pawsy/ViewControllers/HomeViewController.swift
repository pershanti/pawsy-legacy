//
//  HomeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/11/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import Firebase


class HomeViewController: UIViewController {
    
    var user: User?
    var dogs: [DocumentReference] = [DocumentReference]()
    
    
    @IBAction func addNewDog(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewDog", sender: nil)
    }
    
    func checkForDogs(){
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user!.uid)
        let dogList = userDoc.collection("dogs")
        dogList.getDocuments { (querySnapshot, error) in
            if querySnapshot!.isEmpty {
                print("no dog-uments found")
            }
            else{
                for document in (querySnapshot?.documents)! {
                    self.dogs.append(document.reference)
                }
                print(self.dogs)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
