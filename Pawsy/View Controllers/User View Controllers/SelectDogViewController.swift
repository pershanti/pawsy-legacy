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
import SendBirdSDK

class SelectDogViewController: UICollectionViewController {

    @IBAction func dismissFromDog(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addNewDog(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addNewDog", sender: self)
    }

    var dogs: [DocumentSnapshot] = [DocumentSnapshot]()
    var dogImages = [UIImage]()
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    var userID = Auth.auth().currentUser!.uid
    

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
                            let photoURL = snapshot!.data()!["photo"] as! String
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
        cell.dogLabel.text = doc.data()!["name"] as? String
        cell.dogPhoto.image = image
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentDog.sharedInstance.currentReference = dogs[indexPath.row].reference
        currentDog.sharedInstance.image = self.dogImages[indexPath.row]
        currentDog.sharedInstance.documentID = dogs[indexPath.row].documentID
        currentDog.sharedInstance.imageURL = dogs[indexPath.row].data()!["photo"] as! String
        currentDog.sharedInstance.name = dogs[indexPath.row].data()!["name"] as! String
        CheckedInPark.sharedInstance.parkID = nil
        CheckedInPark.sharedInstance.parkReference = nil
        self.loginToSendBird()
        self.performSegue(withIdentifier: "dogSelected", sender: self)
    }

    func loginToSendBird(){
        let profImage = UIImageJPEGRepresentation(currentDog.sharedInstance.image!, 1)
        SBDMain.connect(withUserId: currentDog.sharedInstance.documentID!, completionHandler: { (user, error) in
            if user != nil{
                 print("connected with user ID: ", user!.userId)
                SBDMain.updateCurrentUserInfo(withNickname: currentDog.sharedInstance.name, profileUrl: currentDog.sharedInstance.imageURL!, completionHandler: { (error2) in
                    if error2 == nil{
                        print("updated user info")
                    }
                    else{
                        print(error2.debugDescription)
                    }
                })
            }
            else if error != nil {
                print(error.debugDescription)
            }
        })
    }
}



