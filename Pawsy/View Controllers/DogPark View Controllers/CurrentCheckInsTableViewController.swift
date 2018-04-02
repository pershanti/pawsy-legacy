//
//  CurrentCheckInsTableViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class CurrentCheckInsTableViewController: UITableViewController {

    //current dog singleton
    var signedInDog =  currentDog.sharedInstance
    //checked in park singleton
    var checkedInPark = CheckedInPark.sharedInstance
    var thisParkID: String?
    //firebase user
    var dogCollection = Firestore.firestore().collection("dogs")
    var parkCollection = Firestore.firestore().collection("dogParks")
    var currentUser = Auth.auth().currentUser
    var listOfDogs = [DocumentSnapshot]()

    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")!)

    @IBAction func dismissPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getListOfDogs()
    }

    func getListOfDogs(){
        self.checkedInPark.parkReference!.collection("currentCheckIns").getDocuments(completion: { (Snapshot, Error) in
            if Snapshot != nil{
                self.listOfDogs = [DocumentSnapshot]()
                print(Snapshot?.documents.count)
                for document in Snapshot!.documents{
                    let dogID = document.data()["dogID"] as! String
                    self.dogCollection.document(dogID).getDocument(completion: { (DogDoc, Error2) in
                        if Error2 != nil{
                            print(Error2!.localizedDescription)
                            return
                        }
                        self.listOfDogs.append(DogDoc!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfDogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "checkedDogCell") as! DogCell
        cell.textLabel?.text = self.listOfDogs[indexPath.row].data()!["name"] as! String
        let checkInTime = self.listOfDogs[indexPath.row].data()!["checkInTime"] as! Date
        let timeDifference = checkInTime.timeIntervalSinceNow
        let timeMinutes = Int(-timeDifference/60)
        cell.detailTextLabel?.text = String(describing: timeMinutes) + " minutes"
        let photoURL = self.listOfDogs[indexPath.row].data()!["photo"] as! String
        self.cloudinary.createDownloader().fetchImage(photoURL, nil) { (image, Error) in
            if image != nil{
                DispatchQueue.main.async {
                    cell.myimageView.image = image!
                }
            }
        }
        return cell
    }

}

class DogCell: UITableViewCell {

    @IBOutlet weak var myimageView: UIImageView!

    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.myimageView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setCircularImageView()
    }

    func setCircularImageView() {
        self.myimageView.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        self.myimageView.layer.cornerRadius = CGFloat(roundf(Float(self.myimageView.frame.size.width / 2.0)))
    }
}

