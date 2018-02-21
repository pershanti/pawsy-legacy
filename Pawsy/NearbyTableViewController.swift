
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
    var dogs = [DocumentSnapshot]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        let db = Firestore.firestore().collection("dogs")
        db.getDocuments { (snapshot, error) in
            if error == nil {
                if snapshot!.documents.count != 0{
                    self.dogs = snapshot!.documents
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dog = dogs[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        vc.dog = dog
        vc.photo = images[indexPath.row]
        present(vc, animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        
        let doc = self.dogs[indexPath.row]
        let photoURL = doc.data()["photo"] as! String
        self.cloudinary?.createDownloader().fetchImage(photoURL, nil, completionHandler: { (image, error) in
            DispatchQueue.main.async {
                cell.imageView?.image = image
                self.images.append(image!)
            }
        })
        cell.textLabel?.text = self.dogs[indexPath.row].data()["name"] as? String
        cell.detailTextLabel?.text = self.dogs[indexPath.row].data()["breed"] as? String
        
        return cell
    }

}


