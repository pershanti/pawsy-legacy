//
//  MapPopupViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/20/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class MapPopupViewController: UIViewController {

    var park: Park?
    var delegate: MapPopupViewControllerDelegate?


    @IBOutlet weak var parkPageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!

    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        if checkInButton.titleLabel?.text == "Check In"{
            checkInButton.titleLabel?.text = "Check Out"
            self.delegate!.checkIn()
        }
        else{
            checkInButton.titleLabel?.text = "Check In"
            self.delegate!.checkOut()
        }
    }
    @IBAction func goToParkPageButton(_ sender: UIButton) {
        self.delegate!.goToParkPage()
    }

    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.parkNameLabel.text = "Select a Dog Park"
        self.parkPageButton.setTitleColor(UIColor.white, for: .normal)
        self.dismissButton.setTitleColor(UIColor.white, for: .normal)
        self.checkInButton.setTitleColor(UIColor.white, for: .normal)
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        if self.park == nil{
            self.park = Park(placename: "Select a Dog Park", id: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
        self.parkNameLabel.text = park!.name

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

struct CheckIn {
    var checkInTime: Date?
    var checkOutTime: Date?
    var placeID: String?
    var placeName: String?
    var dogID: String?
    init(cin: Date, place: String, dog: String, name: String) {
        self.checkInTime = cin
        self.placeID = place
        self.dogID = dog
        self.placeName = name
    }
}

protocol MapPopupViewControllerDelegate {
    func goToParkPage()
    func checkIn()
    func checkOut()
}


