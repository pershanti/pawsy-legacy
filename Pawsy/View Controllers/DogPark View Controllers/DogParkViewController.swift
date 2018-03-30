//
//  DogParkViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 3/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class DogParkViewController: UIViewController, MessageViewControllerDelegate {

    //info to show: # dogs checked in for less than 30 min, link to list of dogs, link to group chat

    @IBAction func goToCheckIns(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToListOfCheckIns", sender: self)
    }

    @IBOutlet weak var checkInButton: UIBarButtonItem!
    var park: Park?
    var checkInReferenceDocs =  [DocumentSnapshot]()
    var delegate: DogParkViewControllerDelegate?
    var checkedIn = false
    var lessThan30 = 0

    @IBOutlet weak var lessThan30MinLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    @IBAction func checkInButtonPressed(_ sender: UIBarButtonItem) {
        let park = CheckedInPark.sharedInstance.park
        if park.name != nil{
            self.checkedIn = false
            print("checkedOut")
            self.checkInButton.title = "Check In"
            self.delegate!.checkOut()

        }
        else{
            self.checkedIn = true
            print("checkedIn")
            self.checkInButton.title = "Check Out"
            self.delegate!.checkIn(clickedPark: park)
        }

    }
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.park!.name
        self.getCurrentCheckIns()
        self.delegate!.checkIfCheckedIn()

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
                doc.collection("currentCheckIns").getDocuments( completion: { (snap2, error2) in
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

    //checks how many users have been around for less than 30 minutes
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
        if segue.identifier == "goToListOfCheckIns"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CurrentCheckInsTableViewController
            vc.currentCheckInDocs = self.checkInReferenceDocs
        }
    }

    //MessageViewController Delegate Functions
    func setUpMessageViewController() {
        let popup = self.childViewControllers[0] as! MessageViewController
        popup.delegate = self
        popup.park = self.park!
    }
}



protocol DogParkViewControllerDelegate {
    func checkIn(clickedPark: Park?)
    func checkOut()
    func checkIfCheckedIn()
}
