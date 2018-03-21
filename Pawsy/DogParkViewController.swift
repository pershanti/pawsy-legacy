//
//  DogParkViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 3/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class DogParkViewController: UIViewController {

    var park: Park?
    var checkInReferenceDocs: [DocumentSnapshot]?
    var delegate: DogParkViewControllerDelegate?

    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.park!.name
        self.getCurrentCheckIns()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentCheckIns(){
        let checkInQuery = Firestore.firestore().collection("dogParks").whereField("placeID", isEqualTo: self.park?.placeID)
        checkInQuery.getDocuments { (Snapshot, error) in
            if Snapshot!.documents.count > 0 {
                let doc = Snapshot!.documents[0].reference
                doc.collection("currentCheckIns").addSnapshotListener( { (snap2, error2) in
                    if snap2!.documents.count > 0{
                        self.checkInReferenceDocs = snap2!.documents
                    }
                })
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}

protocol DogParkViewControllerDelegate {
    func checkIn()
    func checkOut()
}
