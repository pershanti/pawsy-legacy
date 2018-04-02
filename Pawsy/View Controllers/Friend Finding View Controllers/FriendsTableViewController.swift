//
//  FriendsTableViewController.swift
//  
//
//  Created by Shantini Vyas on 3/8/18.
//

import UIKit
import Firebase
import Cloudinary




class FriendsTableViewController: UITableViewController {
    
    @IBAction func gotohome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var friends: [DocumentSnapshot] = [DocumentSnapshot]()
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        let currentDogDoc = currentDog.sharedInstance.currentReference
        currentDogDoc?.collection("friends").getDocuments(completion: { (snapshot, error) in
            if snapshot!.documents.count > 0 {
                for doc in snapshot!.documents{
                    self.friends.append(doc)
                    self.tableView.reloadData()
                }
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let doc = self.friends[indexPath.row]
        cell.textLabel!.text = doc.data()!["name"] as? String
        cell.detailTextLabel!.text = doc.data()!["breed"] as? String
        
        let photoURL = doc.data()!["photo"] as! String
        self.cloudinary?.createDownloader().fetchImage(photoURL, nil, completionHandler: { (image, error) in
            DispatchQueue.main.async {
                cell.imageView!.image = image
                cell.imageView!.layer.cornerRadius = cell.imageView!.frame.width/2
                cell.imageView!.layer.masksToBounds = true
            }
        })
        

        return cell
    }
 


}
