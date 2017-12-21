//
//  StatsViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/20/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: StatsViewControllerDelegate?

    @IBOutlet weak var ageBox: UITextField!
    @IBOutlet weak var weightBox: UITextField!
    @IBOutlet weak var breedBox: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem){
        delegate?.didSubmitStats(self, age: self.ageBox.text!, weight: self.weightBox.text!, breed: self.breedBox.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ageBox.delegate = self
        self.weightBox.delegate = self
        self.breedBox.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (
            self.ageBox!.text?.isEmpty == false &&
            self.breedBox!.text?.isEmpty == false &&
            self.weightBox!.text?.isEmpty == false
            ){
            self.saveButton.isEnabled = true
            }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
