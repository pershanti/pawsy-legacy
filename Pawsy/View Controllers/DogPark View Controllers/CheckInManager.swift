//
//  CheckInManager.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import GoogleMaps
import GooglePlaces
import SwiftHTTP
import SwiftyJSON

///These functions manage park check-ins and check-outs
extension MapViewController {

    func checkIn(clickedPark: Park?){
        let currentDogID = currentDog.sharedInstance.documentID!
        //create a new check in and add it to a list of park check ins
        if self.checkInReference == nil{
            print("checkInReference is Nil")
            self.newCheckIn = CheckIn(cin: Date(), place: self.clickedPark.placeID!, dog: currentDogID, name: self.clickedPark.name!)
            self.checkInReference = self.db.collection("allCheckIns").addDocument(data: ["checkInTime" : self.newCheckIn!.checkInTime!, "placeName": self.newCheckIn!.placeName!, "placeID" : self.newCheckIn!.placeID!, "dogID" : self.newCheckIn!.dogID!]){ (error) in
                print("creating new check ins")
                //add the check in to a list specific to this dog park
                print(self.clickedPark.placeID!)
                self.dogParkReference = self.db.collection("dogParks").document(self.clickedPark.placeID!)
                self.dogParkReference?.setData(["placeName": self.newCheckIn!.placeName!, "placeID":self.newCheckIn!.placeID!, "hasChatRoom": false])
                self.dogParkCheckInReference =  self.dogParkReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //add the check in ID to the dog's checkIn collection
                self.dogCheckInReference =  self.dogReference!.collection("checkIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //add the check in ID to the dog's current check ins
                self.dogCurrentCheckInsReference = self.dogReference!.collection("currentCheckIns").addDocument(data: ["checkInReferenceID":self.checkInReference!.documentID])

                //create the park singleton
                CheckedInPark.sharedInstance.park = clickedPark!
                //segue into the park view controller
                self.performSegue(withIdentifier: "goToParkPage", sender: self)
            }
        }
        else{
            //if already checked in, get the details of it and add the check in to a list specific to this dog park
            self.checkInReference!.getDocument(completion: { (snapshot, error) in
                if error == nil{
                    print("got check in document")
                    self.checkInDocument = snapshot!
                    self.checkedInParkPlaceID = self.checkInDocument!.data()!["placeID"] as! String

                    let placeName = self.checkInDocument!.data()!["placeName"] as! String

                    //set dogParkReference (documentID is the same as the placeID)
                    self.dogParkReference = self.db.collection("dogParks").document(self.checkedInParkPlaceID!)

                    //create checked in park Singleton
                    let checkInPark = Park(placename: placeName, id: self.checkedInParkPlaceID!)
                    CheckedInPark.sharedInstance.park = checkInPark

                    //set dogParkCheckInReference
                    self.dogParkReference!.collection("currentCheckIns").whereField("checkInReferenceID", isEqualTo: self.checkInDocument!.documentID).getDocuments(completion: { (snap2, error2) in
                        if snap2!.documents.count > 0 {
                            self.dogParkCheckInReference = snap2!.documents[0].reference
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToParkPage", sender: self)
                            }
                        }
                    })
                }
                else{
                    print(error!.localizedDescription)
                }
            })
        }
    }

    func checkOut(){
        //update the checkIn to add checkOut time
        self.checkInReference?.updateData(["checkOutTime" : Date()])
        //add the check in ID to the park's past check in page
        self.dogParkReference!.collection("pastCheckIns").addDocument(data: ["checkInID":self.checkInReference!.documentID])
        //delete references
        self.dogParkCheckInReference!.delete()
        self.dogCurrentCheckInsReference!.delete()
        self.checkInReference = nil
        self.dogParkReference = nil
        self.dogParkCheckInReference = nil
        self.newCheckIn = nil
        self.dogCurrentCheckInsReference = nil
        self.dogCheckInReference = nil
        CheckedInPark.sharedInstance.park.name = nil
        CheckedInPark.sharedInstance.park.hasChatRoom = false
        CheckedInPark.sharedInstance.park.placeID = nil
        self.gmsmapView.isUserInteractionEnabled = true
    }

    func checkIfCheckedIn() {
        //set checkInReference
        //set dogCurrentCheckInsReference
        print("checkingIfCheckedIn")
        self.dogReference!.collection("currentCheckIns").getDocuments(completion: { (snap, error) in
            if snap!.documents.count > 0 {
                print("thereIsACurrentCheckIn")
                self.dogCurrentCheckInsReference = snap!.documents[0].reference
                let checkInID = snap!.documents[0].data()["checkInReferenceID"] as! String
                print (checkInID)
                self.checkInReference = self.db.collection("allCheckIns").document(checkInID)
                self.checkIn(clickedPark: nil)
            }
            else{
                print("no current checkIns")
            }
        })
    }
}
