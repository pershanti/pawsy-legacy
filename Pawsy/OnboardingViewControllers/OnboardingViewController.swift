//
//  PetNameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/14/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class OnboardingViewController: UIViewController, PlayStylePageViewControllerDelegate, StatsViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var basicInfoButton: UIButton!
    @IBOutlet weak var playStyleButton: UIButton!
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.createNewDog()
        self.photoButton.isHidden = false
        sender.isHidden = true
    }
    @IBAction func showImageUploader(_ sender: UIButton) {
        self.alert.addAction(UIAlertAction(title: "Take New Photo", style: UIAlertActionStyle.default, handler: {_ in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }))
        self.alert.addAction(UIAlertAction(title: "Upload from Library", style: UIAlertActionStyle.default, handler: {_ in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func showStatsViewController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showStatsViewController", sender: self)
    }
    @IBAction func showPlayStylePageViewController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showPlayStylePageViewController", sender: self)
    }
    @IBAction func onboardingComplete(_ sender: UIButton) {
        self.delegate?.didFinishOnboarding(self, data: self.newDog!)
    }
    @IBAction func didPressCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let user = Auth.auth().currentUser!
    var newDog: DataModel?;
    let alert = UIAlertController(title: "Image Source", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
    var imagePicker =  UIImagePickerController()
    var delegate: OnboardingViewControllerDelegate?
    var dogImage: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("image picked")
        picker.dismiss(animated: true, completion: nil)
        self.dogImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.basicInfoButton.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStatsViewController"{
            let destination = segue.destination as! UINavigationController
            let final = destination.childViewControllers[0] as! StatsViewController
            final.delegate = self
        }
        else if segue.identifier == "showPlayStylePageViewController"{
            let destination = segue.destination as! PlayStylePageViewController
            destination.delegate = self
        }
    }
    
    func didSubmitStats(_ controller: StatsViewController, age: String, weight: String, breed: String) {
        self.playStyleButton.isEnabled = true
        self.newDog?.data["age"]  = age.description
        self.newDog?.data["weight"]  = weight.description
        self.newDog?.data["breed"]  = breed
        self.playStyleButton.isHidden = false
        print(self.newDog?.data)
    }
    
    func didGetPlayStyle(_ controller: PlayStylePageViewController, energyLevel: String, dogFeelings: String, humanFeelings: String, roughness: String, ball: String, playScene: String, dogSizePreference: String, lookingFor: String) {
        self.newDog?.data["energyLevel"] = energyLevel.description
        self.newDog?.data["dogFeelings"] =  dogFeelings.description
        self.newDog?.data["humanFeelings"] = humanFeelings.description
        self.newDog?.data["roughness"] = roughness.description
        self.newDog?.data["ball"] = ball.description
        self.newDog?.data["playScene"] = playScene.description
        self.newDog?.data["dogSizePreference"] = dogSizePreference.description
        self.newDog?.data["lookingFor"] = lookingFor.description
        self.submitButton.isHidden = false
        
    }
    
    func createNewDog(){
        self.newDog = DataModel(name: self.nameBox.text!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
