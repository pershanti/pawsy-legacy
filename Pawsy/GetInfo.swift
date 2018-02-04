//
//  GetInfo.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/1/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreData

class GetInfo: UIViewController, BreedViewControllerDelegate {

    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var spayed: UISegmentedControl!
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var weight: UITextField!
    var breed: String?
    
    @IBAction func breedButton(_ sender: UIButton) {
        performSegue(withIdentifier: "selectBreed", sender: self)
    }
    
    @IBAction func finishButton(_ sender: Any) {
        details["gender"] = gender.titleForSegment(at: gender.selectedSegmentIndex)
        details["spayed"] = spayed.titleForSegment(at: spayed.selectedSegmentIndex)
        details["birthdate"] = birthdate.date
        if weight.text != nil{
            details["weight"] = weight.text!
        }
        if breed != nil{
            details["breed"] = breed
        }
        save()
    }
    
    var user: [LocalUser]?
    var details = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
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
        
        //3
        do {
            user = try managedContext.fetch(fetchRequest) as? [LocalUser]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let person = self.user![0]
        // 3
       
        for key in details{
            person.setValuesForKeys(
                [key.key: key.value]
            )
        }
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        print (person.photo?.isEmpty)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectBreed"{
            let destination = segue.destination as! BreedsTableViewController
            destination.delegate = self
        }
    }
    
}

