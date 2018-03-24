//
//  DogParkViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 3/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import ChatSDK

class DogParkViewController: UIViewController {

    //info to show: # dogs checked in for less than 30 min, link to list of dogs, link to group chat

    @IBOutlet weak var checkInButton: UIBarButtonItem!
    var park: Park?
    var checkInReferenceDocs =  [DocumentSnapshot]()
    var delegate: DogParkViewControllerDelegate?
    var checkedIn = false
    var lessThan30 = 0
    @IBOutlet weak var lessThan30MinLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    @IBAction func checkInButtonPressed(_ sender: UIBarButtonItem) {

    }
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = self.park!.name
        self.getCurrentCheckIns()
        let config = BConfiguration()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func getCurrentCheckIns(){
        let checkInQuery = Firestore.firestore().collection("dogParks").whereField("placeID", isEqualTo: self.park?.placeID as Any)
        checkInQuery.getDocuments { (Snapshot, error) in
            if Snapshot!.documents.count > 0 {
                let doc = Snapshot!.documents[0].reference
                doc.collection("currentCheckIns").addSnapshotListener( { (snap2, error2) in
                    if snap2!.documents.count > 0{
                        self.checkInReferenceDocs = snap2!.documents
                        DispatchQueue.main.async {
                            self.updateCheckInStatus()
                        }
                    }
                })
            }
        }
    }

    func updateCheckInStatus(){
        self.checkedInLabel.text = String(describing: self.checkInReferenceDocs.count)
        self.lessThan30 = 0
        for checkIn in self.checkInReferenceDocs{
            let id = checkIn.data()!["checkInReferenceID"] as! String
            Firestore.firestore().collection("allCheckIns").document(id).getDocument(completion: { (snapshot, error) in
                let checkInTime = snapshot!.data()!["checkInTime"] as! Date
                let difference = -(checkInTime.timeIntervalSinceNow)
                print(difference)
                if Int(difference) < 1800{
                    self.lessThan30 += 1
                    DispatchQueue.main.async {
                        self.lessThan30MinLabel.text = String(describing: self.lessThan30)
                    }
                }
            })
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
    func checkIfCheckedIn()
}
