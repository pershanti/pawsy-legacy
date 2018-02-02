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

class GetName: UIViewController, UITextFieldDelegate{
    
    @IBAction func continueButton(_ sender: UIButton) {
        self.save(name: self.nameBox.text!)
        self.performSegue(withIdentifier: "goToPhoto", sender: self)
     }
    
    
    @IBOutlet weak var nameBox: UITextField!
    
    var lottieName = "ModernPictogramsForLottie_Text"
    
    func save(name: String){
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
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameBox.resignFirstResponder()
        return true
    }

}
