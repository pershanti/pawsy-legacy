//
//  PetNameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/14/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class PetNameViewController: UIViewController {
    
    let user = Auth.auth().currentUser!

    @IBOutlet weak var nameBox: UITextField!
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let userDoc = Firestore.firestore().collection("users").document(user.uid)
        let dogDoc = userDoc.collection("dogs").document()
        dogDoc.setData([
            "name": self.nameBox.text
            ])
        self.performSegue(withIdentifier: "goToPhotoUpload", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
