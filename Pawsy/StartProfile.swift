//
//  GetName.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/31/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie
import CoreData
import Firebase

class StartProfile: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var spayed: UISegmentedControl!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var nameBox: UITextField!
    var details = [String:Any]()
    var photo: Data?
    var photoUpload: UIImagePickerController = UIImagePickerController()
    var alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    var dogID: String?
    
    @IBAction func continueButton(_ sender: UIButton) {
        let dogRef = Firestore.firestore().collection("dogs").addDocument(data: [:])
        dogID = dogRef.documentID
        details["firebaseID"] = dogID!
        details["gender"] = gender.titleForSegment(at: gender.selectedSegmentIndex)
        details["spayed"] = spayed.titleForSegment(at: spayed.selectedSegmentIndex)
        if nameBox.text != nil{
            details["name"] = nameBox.text!
        }
        if weight.text != nil{
            details["weight"] = weight.text!
        }
        if self.photo != nil{
            details["photo"] = self.photo!
        }
        
        save()
        self.performSegue(withIdentifier: "finishProfile", sender: self)

    }
    
    @IBAction func getPhoto(_ sender: UIButton) {
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishProfile"{
            let destination = segue.destination as! FinishProfile
            destination.dogID = self.dogID!
        }
    }

    func save(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "LocalUser",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        for key in details{
            person.setValuesForKeys(
                [key.key: key.value]
            )
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        setUpAlertController()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpAlertController(){
        self.photoUpload.delegate = self
        self.alert.addAction(UIAlertAction(title: "Take New Photo", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.photoUpload.sourceType = .camera
            self.present(self.photoUpload, animated: true, completion: nil)
        }))
        self.alert.addAction(UIAlertAction(title: "Select From Photo Library", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.photoUpload.sourceType = .photoLibrary
            self.present(self.photoUpload, animated: true, completion: nil)
        }))
        
        self.alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            
        }))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.photo = UIImageJPEGRepresentation(image, 1)
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
