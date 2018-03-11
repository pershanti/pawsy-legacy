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
    
    @IBOutlet weak var Gender: UIStackView!
    @IBOutlet weak var Fixed: UIStackView!
    @IBOutlet weak var agePicker: UIDatePicker!
    @IBOutlet weak var Weight: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var selectBreed: UIButton!
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var selectPhoto: UIButton!
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
    var dogGender: String?
    var dogFixed: String?
    var dogDoc: DocumentReference?
    
    @IBAction func boy(_ sender: UIButton) {
        self.dogGender = "Male"
    }
    
    @IBAction func girl(_ sender: UIButton) {
        self.dogGender = "Female"
    }
    
    @IBAction func genderNeutral(_ sender: UIButton) {
        self.dogGender = "No Gender"
    }
    
    @IBAction func fixedYes(_ sender: UIButton) {
        self.dogFixed = "Yes"
    }
    
    @IBAction func fixedNo(_ sender: UIButton) {
        self.dogFixed = "No"
    }
    
    
    
    
    @IBAction func photoButton(_ sender: UIButton) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func breedButton(_ sender: UIButton) {
        let breedsVC = storyboard?.instantiateViewController(withIdentifier: "breeds") as! BreedTableViewController
        breedsVC.delegate = self
        present(breedsVC, animated: true, completion: nil)
    }
    
    
    //cycle through screen images until last screen reached
    @IBAction func next(_ sender: Any) {
        if  selectPhoto.isHidden == false {
            let alert = UIAlertController(title: "No Image Selected", message: "Please select an image to upload", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if (Name.text?.count)! < 1 && Name.isHidden == false {
                print("is Nil")
                let alert = UIAlertController(title: "No Name Entered", message: "Please enter a name.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
        }
            
        else if (Weight.text?.count)! < 1 && Weight.isHidden == false {
                let alert = UIAlertController(title: "No Weight Entered", message: "Please enter a number for weight.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
        }
            
        else if Gender.isHidden == false && self.dogGender == nil{
            
            let alert = UIAlertController(title: "No Gender Selected", message: "Please select a gender.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if Fixed.isHidden == false && self.dogFixed == nil{
            
            let alert = UIAlertController(title: "No Spay/Neuter Status Selected", message: "Please select an option.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
       
        else if self.breed == nil && selectBreed.isHidden == false {
                let alert = UIAlertController(title: "No Breed Selected", message: "Please select a breed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
        }
        else if currentInput < inputImages.count-1 {
            self.cycleImages()
        }
        
        else {
            self.inputImageView.image = UIImage(named:"purpleScreen")
            self.profilePhoto.isHidden = true
            let newFrame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2-100, width: 200, height: 200)
            let lottieView = LOTAnimationView(name: "loading")
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
    
    func cycleImages(){
        print ("cycling")
        itemList![currentInput].isHidden = true
        currentInput += 1
        inputImageView.image = inputImages[currentInput]
        itemList![currentInput].isHidden = false
        itemList![currentInput].center.x = view.center.x
        if self.profilePhoto.isHidden == false{
            self.profilePhoto.isHidden = true
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.photo = UIImageJPEGRepresentation(image, 1)!
        self.selectPhoto.isHidden = true
        self.profilePhoto.image = image
        self.profilePhoto.layer.masksToBounds = true
        self.profilePhoto.frame = CGRect(x: 87, y: 200, width: 200, height: 200)
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width/2
        
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
        self.inputImages.append(UIImage(named:"NamePage")!)
        self.inputImages.append(UIImage(named:"WeightPage")!)
        self.inputImages.append(UIImage(named:"BirthdatePage")!)
        self.inputImages.append(UIImage(named:"GenderPage")!)
        self.inputImages.append(UIImage(named:"FixPage")!)
        self.inputImages.append(UIImage(named:"BreedPage")!)
        self.inputImages.append(UIImage(named:"PicPage")!)
        self.inputImageView.image = self.inputImages[0]
        itemList = [Name, Weight, agePicker, Gender, Fixed, selectBreed, selectPhoto]
        agePicker.setValue(UIColor.black, forKeyPath: "textColor")
        agePicker.backgroundColor = UIColor.white
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
                self.uploadToFirebase(photoURL: String(describing: result!.resultJson["url"]!))
                
            }
        })
    }

    
    func uploadToFirebase(photoURL: String){
        let db = Firestore.firestore()
        self.dogDoc = db.collection("dogs").addDocument(data: [
            "name": self.Name.text!,
            "weight": self.Weight.text!,
            "birthdate": self.agePicker.date,
            "photo": photoURL,
            "gender": dogGender!,
            "fixed": dogFixed!,
            "breed": self.breed!
        ])
        if self.locationManager.location != nil {
            dogDoc?.updateData(["longitude":self.locationManager.location!.coordinate.longitude, "latitude":self.locationManager.location!.coordinate.latitude])
        }
        
        let user = Auth.auth().currentUser!
        let userDoc = db.collection("users").document(user.uid)
        userDoc.collection("dogs").addDocument(data: ["dogID": dogDoc?.documentID])
        currentDog.sharedInstance.currentReference = self.dogDoc!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
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
