//
//  GenderViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/13/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var gender = ["Male, Intact", "Female, Intact", "Male, Neutered", "Female, Spayed"]
    
    var selectedGender: String?
    
    @IBAction func nextButton(_ sender: UIButton) {
        let parent = self.parent as! NewDogPageViewController
        parent.gender = selectedGender
        parent.setViewControllers([parent.pages[5]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBOutlet weak var genderPicker: UIPickerView!
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedGender = gender[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
