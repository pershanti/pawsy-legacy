//
//  SelectDogCollectionViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/17/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class SelectDogViewController: UICollectionViewController {

    @IBAction func dismissFromDog(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    var dogs: [DocumentSnapshot] = [DocumentSnapshot]()
    var dogImages = [UIImage]()
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")

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
                                    DispatchQueue.main.async {
                                        self.dogImages.append(image!)
                                        self.dogs.append(snapshot!)
                                        self.collectionView!.reloadData()
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dogs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogSelectCell", for: indexPath) as! DogPhotoCollectionViewCell
        let doc = self.dogs[indexPath.row]
        let image = self.dogImages[indexPath.row]
        cell.dogLabel.text = doc.data()["name"] as? String
        cell.dogPhoto.image = image
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentDog.sharedInstance.currentReference = dogs[indexPath.row].reference
        self.performSegue(withIdentifier: "dogSelected", sender: self)
    }

}



