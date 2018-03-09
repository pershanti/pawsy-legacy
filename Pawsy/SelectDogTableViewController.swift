//
//  SelectDogTableViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 3/8/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class SelectDogTableViewController: UITableViewController {
    
    var dogs: [DocumentSnapshot] = [DocumentSnapshot]()
    
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        let currentUserID = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("users").document(currentUserID).collection("dogs").getDocuments { (snap, err) in
            if snap!.documents.count > 0 {
                for doc in snap!.documents{
                    self.dogs.append(doc)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = dogs[indexPath.row]
        currentDog.sharedInstance.currentReference = current.reference
        self.performSegue(withIdentifier: "dogSelected", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogCell", for: indexPath)
        let doc = self.dogs[indexPath.row]
        cell.textLabel?.text = doc.data()["name"] as? String
        let photoURL = doc.data()["photo"] as! String
        self.cloudinary?.createDownloader().fetchImage(photoURL, nil, completionHandler: { (image, error) in
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        })

        return cell
    }
 

}
