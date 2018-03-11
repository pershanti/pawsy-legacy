
//  NearbyTableViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/17/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Cloudinary
import Firebase

class NearbyTableViewController: UITableViewController {
    
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    var dogs = [Dog]()
    var dogForProfile: DocumentSnapshot?
    
    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        let db = Firestore.firestore().collection("dogs")
        db.getDocuments { (snapshot, error) in
            if error == nil {
                if snapshot!.documents.count != 0{
                    for doc in snapshot!.documents{
                        let photoURL = doc.data()["photo"] as! String
                        self.cloudinary?.createDownloader().fetchImage(photoURL, nil, completionHandler: { (image, error) in
                            if error != nil{
                                print(error?.description)
                            }
                            if image != nil{
                                let newDog = Dog()
                                newDog.doc = doc
                                newDog.image = image!
                                self.dogs.append(newDog)
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileFromNearby"{
            let nav = segue.destination as! UINavigationController
            let profile = nav.childViewControllers[0] as! ProfileViewController
            profile.dog = self.dogForProfile!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dogForProfile = dogs[indexPath.row].doc
        self.performSegue(withIdentifier: "goToProfileFromNearby", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! Cell
        
        let dog = self.dogs[indexPath.row]
        cell.myimageView.image = dog.image
        cell.setCircularImageView()
        cell.textLabel?.text = dog.doc!.data()["name"] as? String
        cell.detailTextLabel?.text = dog.doc!.data()["breed"] as? String
        
        return cell
    }

}

class Cell: UITableViewCell {
    
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
        self.myimageView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        self.myimageView.layer.cornerRadius = CGFloat(roundf(Float(self.myimageView.frame.size.width / 2.0)))
    }
}

class Dog {
    var image: UIImage?
    var doc: DocumentSnapshot?
}


