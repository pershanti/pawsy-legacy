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
import DLRadioButton

class InputViewController: UIViewController, BreedViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var Gender: UIStackView!
    @IBOutlet weak var Fixed: UIStackView!
    @IBOutlet weak var agePicker: UIDatePicker!
    @IBOutlet weak var Weight: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var selectBreed: UIButton!
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var boyButton: DLRadioButton!
    @IBOutlet weak var girlButton: DLRadioButton!
    @IBOutlet weak var noButton: DLRadioButton!
    @IBOutlet weak var yesButton: DLRadioButton!

    var currentInput: Int = 0
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
    let user = Auth.auth().currentUser!

    @IBAction func boy(_ sender: UIButton) {
        self.dogGender = "Male"
    }
    @IBAction func girl(_ sender: UIButton) {
        self.dogGender = "Female"
    }
    @IBAction func fixedYes(_ sender: UIButton) {
        self.dogFixed = "Yes"
    }
    @IBAction func fixedNo(_ sender: UIButton) {
        self.dogFixed = "No"
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        self.manageViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.profilePhoto.clipsToBounds = true
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width / 2
    }

    override func viewDidLoad() {
        hideKeyboard()
        setUpAlertController()
        photoPicker.delegate = self
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        self.boyButton.otherButtons = [self.girlButton]
        self.boyButton.isMultipleSelectionEnabled = false
        self.yesButton.otherButtons = [self.noButton]
        self.yesButton.isMultipleSelectionEnabled = false
        manageViews()
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

    func manageViews(){
        switch self.currentInput {
        case 0:
            self.Name.isHidden = false
            self.inputImageView.image = UIImage(named:"NamePage")!
            self.currentInput += 1
            return
        case 1:
            if (Name.text?.count)! < 1 {
                print("is Nil")
                let alert = UIAlertController(title: "No Name Entered", message: "Please enter a name.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.Weight.isHidden = false
                self.Name.isHidden = true
                self.inputImageView.image = UIImage(named:"WeightPage")!
                self.currentInput += 1
                return
            }
        case 2:
            if (Weight.text?.count)! < 1 {
                let alert = UIAlertController(title: "No Weight Entered", message: "Please enter a number for weight.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.Weight.isHidden = true
                self.agePicker.isHidden = false
                agePicker.setValue(UIColor.black, forKeyPath: "textColor")
                agePicker.backgroundColor = UIColor.white
                self.inputImageView.image = UIImage(named:"BirthdatePage")!
                self.currentInput += 1
                return
            }
        case 3:
            self.agePicker.isHidden = true
            self.Gender.isHidden = false
            self.inputImageView.image = UIImage(named:"GenderPage")!
            self.currentInput += 1
            return
        case 4:
            if  self.dogGender == nil{
                let alert = UIAlertController(title: "No Gender Selected", message: "Please select a gender.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.Gender.isHidden = true
                self.Fixed.isHidden = false
                self.inputImageView.image = UIImage(named:"FixPage")!
                self.currentInput += 1
                return
            }

        case 5:
            if self.dogFixed == nil{
                let alert = UIAlertController(title: "No Spay/Neuter Status Selected", message: "Please select an option.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.Fixed.isHidden = true
                self.selectBreed.isHidden = false
                self.inputImageView.image = UIImage(named:"BreedPage")!
                self.currentInput += 1
                return
            }

        case 6:
            if self.breed == nil  {
                let alert = UIAlertController(title: "No Breed Selected", message: "Please select a breed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.selectBreed.isHidden = true
                self.breedLabel.isHidden = true
                self.selectPhoto.isHidden = false
                self.inputImageView.image = UIImage(named:"PicPage")!
                self.currentInput += 1
                return
            }

        case 7:
            if  self.profilePhoto == nil {
                let alert = UIAlertController(title: "No Image Selected", message: "Please select an image to upload", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (uialert) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                self.selectPhoto.isHidden = true
                self.profilePhoto.isHidden = true
                self.inputImageView.isHidden = true
                self.nextButton.isHidden = true
                let newFrame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2-100, width: 200, height: 200)
                let lottieView = LOTAnimationView(name: "loading")
                lottieView.frame = newFrame
                lottieView.loopAnimation = true
                self.view.addSubview(lottieView)
                lottieView.play()
                self.uploadToCloudinary(photo: self.photo!)
                return
            }
        default:
            return
        }
    }

    //delegate method for breed selector
    func goBack(breed: String) {
        self.breed = breed
        self.breedLabel.text = breed
        self.breedLabel.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.photo = UIImageJPEGRepresentation(image, 1)!
        self.profilePhoto.image = image
        self.profilePhoto.isHidden = false

        
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
            "breed": self.breed!,
            "checkedInParkID": "0"
        ])
        if self.locationManager.location != nil {
            dogDoc?.updateData(["longitude":self.locationManager.location!.coordinate.longitude, "latitude":self.locationManager.location!.coordinate.latitude])
        }

        let userDoc = db.collection("users").document(self.user.uid)
        userDoc.collection("dogs").addDocument(data: ["dogID": dogDoc?.documentID])
        currentDog.sharedInstance.currentReference = self.dogDoc!
        currentDog.sharedInstance.documentID = self.dogDoc!.documentID
        currentDog.sharedInstance.image = self.profilePhoto.image
        currentDog.sharedInstance.imageURL = photoURL
        currentDog.sharedInstance.name = self.Name.text!
        self.performSegue(withIdentifier: "loadHome", sender: nil)
        
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
