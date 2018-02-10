//
//  FinishProfile.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/9/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie
import CoreData
import Firebase

class FinishProfile: UIViewController, BreedViewControllerDelegate {
    
    var breed: String?
    var details = [String:Any]()
    var user: LocalUser?
    var firebaseID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBAction func continueButton(_ sender: UIButton) {
        
        details["birthdate"] = birthdate.date
        if breed != nil{
            details["breed"] = breed
        }
        save()
        self.performSegue(withIdentifier: "saveProfileData", sender: self)
        
    }

    @IBAction func breedButton(_ sender: UIButton) {
        let breedsVC = storyboard?.instantiateViewController(withIdentifier: "breeds") as! BreedsTableViewController
        breedsVC.delegate = self
        present(breedsVC, animated: true, completion: nil)
    }
    
    func save(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let person = self.user
        
        for key in details{
            person?.setValuesForKeys(
                [key.key: key.value]
            )
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        print (person)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.birthdate.setValue(UIColor.white, forKeyPath: "textColor")
        self.fetchUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func goBack(breed: String) {
        self.breed = breed
    }
    
    func fetchUser(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "LocalUser")
        
        let predicate = NSPredicate(format: "firebaseID = \(self.firebaseID!)")
        fetchRequest.predicate = predicate
        
        do {
            user = (try managedContext.fetch(fetchRequest)[0] as? LocalUser)!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

