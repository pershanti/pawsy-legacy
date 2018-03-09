
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
    var dogPhotos = [UIImage]()
    
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
                                self.dogs.append(doc)
                                self.dogPhotos.append(image!)
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dog = dogs[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        vc.dog = dog
        present(vc, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let doc = self.dogs[indexPath.row]
        let image = self.dogPhotos[indexPath.row]
        cell.imageView!.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cell.imageView!.image = image
        cell.imageView!.layer.cornerRadius = cell.imageView!.frame.width/2
        cell.imageView!.layer.masksToBounds = true
        cell.textLabel?.text = doc.data()["name"] as? String
        cell.detailTextLabel?.text = doc.data()["breed"] as? String
        
        return cell
    }

}


