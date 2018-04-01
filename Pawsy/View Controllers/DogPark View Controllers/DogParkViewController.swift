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

    var timeSpentCheckedIn: TimeInterval?

    //info to show: # dogs checked in for less than 30 min, link to list of dogs, link to group chat
    @IBAction func goToDiscussionBoard(_ sender: UIButton) {
        //segue
    }

    @IBAction func goToCheckIns(_ sender: UIButton) {
        //segue
    }
    @IBOutlet weak var checkInButton: UIBarButtonItem!
    @IBOutlet weak var howLongYouveBeenHere: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    @IBAction func checkInButtonPressed(_ sender: UIBarButtonItem) {

    }
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.thisParkID == self.checkedInPark.parkID{
            //change the check in button to say "checked out"
            //update how long you've been there
            //send notifications on how long you've been checked in
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToListOfCheckIns"{

        }
    }

    func checkIn(){

    }
    func checkOut(){

    }

}

