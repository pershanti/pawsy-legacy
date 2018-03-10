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
    var dogImages = [UIImage]()
    
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    
    @IBAction func goHomeFromDog(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        let currentUserID = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("users").document(currentUserID).collection("dogs").getDocuments { (snap, err) in
            if snap!.documents.count > 0 {
                for doc in snap!.documents{
                    let dogID = doc.data()["dogID"] as! String
                    Firestore.firestore().collection("dogs").document(dogID).getDocument(completion: { (snapshot, error) in
                        if snapshot != nil{
                            let photoURL = snapshot!.data()["photo"] as! String
                            self.cloudinary?.createDownloader().fetchImage(photoURL, nil, completionHandler: { (image, cloudErr) in
                                if image != nil{
                                    self.dogImages.append(image!)
                                    self.dogs.append(snapshot!)
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    })
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
        let image = self.dogImages[indexPath.row]
        cell.textLabel?.text = doc.data()["name"] as? String
        cell.imageView!.image = image
         cell.imageView!.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cell.imageView!.layer.masksToBounds = true
        cell.imageView!.layer.cornerRadius = cell.imageView!.frame.width/2
        return cell
    }
 

}
