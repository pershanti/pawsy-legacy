//
//  InputViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary
import CoreLocation
import Lottie


class InputViewController: UIViewController, BreedViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var agePicker: UIDatePicker!
    @IBOutlet weak var Weight: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Fixed: UISegmentedControl!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var selectBreed: UIButton!
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBAction func photoButton(_ sender: UIButton) {
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func breedButton(_ sender: UIButton) {
        let breedsVC = storyboard?.instantiateViewController(withIdentifier: "breeds") as! BreedTableViewController
        breedsVC.delegate = self
        present(breedsVC, animated: true, completion: nil)
    }
    @IBOutlet weak var profilePhoto: UIImageView!
    
    var currentInput: Int = 0
    var inputImages = [UIImage]()
    var itemList: [UIView]?
    var breed: String?
    var alertController: UIAlertController = UIAlertController()
    var photoPicker: UIImagePickerController = UIImagePickerController()
    var photo: Data?
    var cloudinary: CLDCloudinary?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    let locationManager = CLLocationManager()
    
    //cycle through screen images until last screen reached
    @IBAction func next(_ sender: UIButton) {
        if currentInput < inputImages.count-1{
            itemList![currentInput].isHidden = true
            currentInput += 1
            inputImageView.image = inputImages[currentInput]
            itemList![currentInput].isHidden = false
            itemList![currentInput].center = view.center
            if self.profilePhoto.isHidden == false{
                self.profilePhoto.isHidden = true
            }
        }
        else{
            self.inputImageView.image = UIImage(named:"grass")
            self.selectBreed.isHidden = true
            let newFrame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2-100, width: 200, height: 200)
            let lottieView = LOTAnimationView(name: "acrobatics")
            lottieView.frame = newFrame
            lottieView.loopAnimation = true
            self.view.addSubview(lottieView)
            lottieView.play()
            self.uploadToCloudinary(photo: self.photo!)
        }
    }
    
    //delegate method for breed selector
    func goBack(breed: String) {
        self.breed = breed
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.photo = UIImageJPEGRepresentation(image, 1)!
        self.profilePhoto.image = image
        self.profilePhoto.isHidden = false
        self.selectPhoto.isHidden = true
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width/2
        self.profilePhoto.layer.masksToBounds = true
        self.inputImageView.image = UIImage(named: "grass2")
    }
    
    func setUpAlertController(){
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (alertAction) in
            self.photoPicker.sourceType = .camera
            self.present(self.photoPicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Upload Photo", style: .default, handler: { (alertAction) in
            self.photoPicker.sourceType  = .photoLibrary
            self.present(self.photoPicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
    func setUpImages(){
        self.inputImages.append(UIImage(named:"name")!)
        self.inputImages.append(UIImage(named:"photo")!)
        self.inputImages.append(UIImage(named:"weight")!)
        self.inputImages.append(UIImage(named:"birthday")!)
        self.inputImages.append(UIImage(named:"gender")!)
        self.inputImages.append(UIImage(named:"fixed")!)
        self.inputImages.append(UIImage(named:"breed")!)
        self.inputImageView.contentMode = .scaleAspectFill
        self.inputImageView.image = self.inputImages[0]
        itemList = [Name, selectPhoto, Weight, agePicker, Gender, Fixed, selectBreed]
        agePicker.setValue(UIColor.white, forKeyPath: "textColor")
        agePicker.backgroundColor = UIColor.darkGray
        itemList![0].isHidden = false
        itemList![0].center = view.center
        self.profilePhoto.frame = CGRect(x: 0, y:0 , width: 200, height: 200)
        self.profilePhoto.contentMode = .scaleAspectFit
        self.profilePhoto.center = view.center
        
    }
    
    func uploadToCloudinary(photo: Data) {
        
        _ = self.cloudinary?.createUploader().upload(data: photo, uploadPreset: "pawsyDogPic", params: nil, progress: {({ (progress) in
            print(progress)
        })}(), completionHandler: { (result, error) in
            if error != nil{
                print(error!)
            }
            else{
                self.uploadToFirebase(photoURL: String(describing: result?.resultJson["url"]!))
                
            }
        })
    }

    
    func uploadToFirebase(photoURL: String){
        let db = Firestore.firestore()
        let dogDoc = db.collection("dogs").addDocument(data: [
            "name": self.Name.text!,
            "weight": self.Weight.text!,
            "birthdate": self.agePicker.date,
            "photo": photoURL,
            "gender": Gender.titleForSegment(at: Gender.selectedSegmentIndex)!,
            "fixed": Fixed.titleForSegment(at: Fixed.selectedSegmentIndex)!,
            "breed": self.breed!
        ])
        if self.locationManager.location != nil {
            dogDoc.updateData(["longitude":self.locationManager.location!.coordinate.longitude, "latitude":self.locationManager.location!.coordinate.latitude])
        }
        
        let user = Auth.auth().currentUser!
        let userDoc = db.collection("users").document(user.uid)
        userDoc.collection("dogs").addDocument(data: ["dogID": dogDoc.documentID])
        self.performSegue(withIdentifier: "loadHome", sender: nil)
        
    }
    
    override func viewDidLoad() {
        setUpImages()
        hideKeyboard()
        setUpAlertController()
        photoPicker.delegate = self
        self.cloudinary = CLDCloudinary(configuration: self.config!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension UIViewController
{
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
