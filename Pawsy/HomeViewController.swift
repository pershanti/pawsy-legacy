//
//  HomeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/21/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    var listOfDogIDs: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getDogs(){
        let currentUser = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection("users").document(currentUser).collection("dogs").getDocuments(completion: { (snapshot, error) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
