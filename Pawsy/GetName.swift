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

class GetName: UIViewController, UITextFieldDelegate, BreedViewControllerDelegate{
    
   
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var spayed: UISegmentedControl!
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var breedLabel: UILabel!
    var breed: String?
    var details = [String:Any]()
    var lottieName = "ModernPictogramsForLottie_Text"

    
    @IBAction func continueButton(_ sender: UIButton) {
        details["gender"] = gender.titleForSegment(at: gender.selectedSegmentIndex)
        details["spayed"] = spayed.titleForSegment(at: spayed.selectedSegmentIndex)
        details["birthdate"] = birthdate.date
        if breed != nil{
            details["breed"] = breed
        }
        if nameBox.text != nil{
            details["name"] = nameBox.text!
        }
        if weight.text != nil{
            details["weight"] = weight.text!
        }
        save()
        self.performSegue(withIdentifier: "goToPhoto", sender: self)
        
    }
    
    @IBAction func breedButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showBreeds", sender: self)
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func goBack(breed: String) {
        self.breed = breed
        self.breedLabel.text = breed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBreeds"{
            let destination = segue.destination as! BreedsTableViewController
            destination.delegate = self
        }
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
