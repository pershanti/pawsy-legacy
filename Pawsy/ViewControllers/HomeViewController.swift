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
    var dogs: [DocumentSnapshot] = [DocumentSnapshot]()
  
    
    @IBAction func addNewDog(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewDog", sender: nil)
    }
    
    func checkForDogs(){
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user!.uid)
        let dogList = userDoc.collection("dogs")
        dogList.getDocuments { (querySnapshot, error) in
            if querySnapshot!.documents.isEmpty  {
                print("no dog-uments found")
            }
            else{
                print(querySnapshot!.count)
                for document in (querySnapshot?.documents)! {
                    self.dogs.append(document)
                    print(document.documentID)
                }
            }
        }
    }
    
    func displayDogs(){
        for i in 0..<dogs.count{
            var ref = self.dogs[i]
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        checkForDogs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
