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

    //current dog singleton
    var signedInDog =  currentDog.sharedInstance
    //checked in park singleton
    var checkedInPark = CheckedInPark.sharedInstance
    var thisParkID: String?
    
    //firebase user
    var dogCollection = Firestore.firestore().collection("dogs")
    var parkCollection = Firestore.firestore().collection("dogParks")
    var currentUser = Auth.auth().currentUser
    var checkInDoc: DocumentReference?
    var checkInTime: Date?
    var numberCheckedIn: Int?
    var timer: Timer!

    var parkName: String?

    var timeSpentCheckedIn: TimeInterval?

    //info to show: # dogs checked in for less than 30 min, link to list of dogs, link to group chat
    @IBAction func goToDiscussionBoard(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMessageBoard", sender: self)
    }

    @IBAction func goToCheckIns(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToListOfCheckIns", sender: self)
    }
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var howLongYouveBeenHere: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!

    @IBOutlet weak var goToCheckInsButton: UIButton!
    @IBOutlet weak var goToDiscussionBoardButton: UIButton!



    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        if self.checkedInPark.parkID == nil{
            self.checkInButton.setTitle("CheckOut", for: .normal) 
            self.goToCheckInsButton.isEnabled = true
            self.goToDiscussionBoardButton.isEnabled = true
            self.checkIn()
        }
        else{
             self.checkInButton.setTitle("CheckOut", for: .normal)
            self.checkOut()
            self.goToCheckInsButton.isEnabled = false
            self.goToDiscussionBoardButton.isEnabled = false
        }

    }
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        if self.checkedInPark.parkID == nil{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = self.parkName!
        if self.thisParkID == self.checkedInPark.parkID{
            self.restoreCheckInSession()
            //change the check in button to say "checked out"
            //update how long you've been there
            //send notifications on how long you've been checked in

        }
        self.getNumberOfCheckIns()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToListOfCheckIns"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CurrentCheckInsTableViewController
            vc.thisParkID = self.thisParkID!
        }
        else if segue.identifier == "goToMessageBoard"{
             let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! MessageViewController
            vc.parkName = self.parkName!
        }
    }

    func restoreCheckInSession(){
        self.parkCollection.document(self.thisParkID!).collection("currentCheckIns").whereField("dogID", isEqualTo: self.signedInDog.documentID).getDocuments { (Snapshot, Error) in
            if Snapshot!.documents.count > 0 {
                self.checkInDoc = Snapshot!.documents[0].reference
                self.checkInTime = Snapshot!.documents[0].data()["checkInTime"] as! Date
                self.checkedInPark.parkID = self.thisParkID
                self.checkedInPark.parkReference = self.parkCollection.document(self.thisParkID!)
                DispatchQueue.main.async {
                    self.checkInButton.setTitle("CheckOut", for: .normal)
                    self.goToCheckInsButton.isEnabled = true
                    self.goToDiscussionBoardButton.isEnabled = true
                    self.update()
                }
            }
        }
    }

    func checkIn(){
        //create check in document
        //change dog document value to show check in
        //update singleton
        self.howLongYouveBeenHere.text = "0 minutes"
        self.checkInTime = Date()
        self.checkInDoc = self.parkCollection.document(self.thisParkID!).collection("currentCheckIns").addDocument(data: ["checkInTime": self.checkInTime!, "dogID":self.signedInDog.documentID, "dogParkID":self.thisParkID])
        self.signedInDog.currentReference!.updateData(["checkedInParkID": self.thisParkID!, "checkInTime": self.checkInTime])
        self.checkedInPark.parkID = self.thisParkID
        self.checkedInPark.parkReference = self.parkCollection.document(self.thisParkID!)
        DispatchQueue.main.async {
            self.getNumberOfCheckIns()
            self.update()
        }
    }


    func checkOut(){
        self.checkInDoc!.updateData(["checkOutTime" : Date()])
        self.checkInDoc!.getDocument(completion: { (Snapshot, Error) in
            if Snapshot != nil{
                //move check in to past check ins
                //add a past check in doc to the dog
                let checkInData = Snapshot!.data()!
                self.checkedInPark.parkReference!.collection("pastCheckIns").addDocument(data: checkInData)
                self.signedInDog.currentReference!.collection("pastCheckIns").addDocument(data: checkInData)
                //delete document
                Snapshot!.reference.delete()
                //update dog document's check in value
                self.signedInDog.currentReference!.updateData(["checkedInParkID":"0", "checkInTime" : nil])
                //update singleton
                self.checkedInPark.parkID = nil
                self.checkedInPark.parkReference = nil
                self.checkInTime = nil
                self.howLongYouveBeenHere.text = "Not Checked In"
                self.getNumberOfCheckIns()
            }
        })
    }

    func getNumberOfCheckIns(){
        self.parkCollection.document(self.thisParkID!).collection("currentCheckIns").getDocuments(completion: { (Snapshot, Error) in
            if Snapshot != nil{
                self.checkedInLabel.text = String(describing: Snapshot!.documents.count)
            }
        })
    }

    @objc func update() {
        print("updating")
        if self.checkInTime != nil{
            let timeDifference = self.checkInTime!.timeIntervalSinceNow
            let timeMinutes = Int(-timeDifference/60)
            self.howLongYouveBeenHere.text = String(describing: timeMinutes) + " minutes"
            self.getNumberOfCheckIns()
        }
    }
}
