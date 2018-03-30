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

    var currentCheckInDocs = [DocumentSnapshot]()
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")!)
    @IBAction func dismissPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.currentCheckInDocs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkedDogCell", for: indexPath)
        
        let dog = self.currentCheckInDocs[indexPath.row]
        let dogName = dog.data()!["name"] as! String
        let dogPicURL = dog.data()!["photo"] as! String
        self.cloudinary.createDownloader().fetchImage(dogPicURL, nil) { (image, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            DispatchQueue.main.async {
                cell.imageView!.image = image
            }
        }
        cell.textLabel!.text = dogName
        return cell
    }

}

protocol CheckInViewControllerDelegate {

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
        self.myimageView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        self.myimageView.layer.cornerRadius = CGFloat(roundf(Float(self.myimageView.frame.size.width / 2.0)))
    }
}
