//
//  WeightViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var weightPicker: UIPickerView!
    @IBAction func nextButton(_ sender: UIButton) {
        let parent = self.parent as! NewDogPageViewController
        
        if self.weight != nil{
            parent.weight = self.weight
        }
        else{
            weight = pickerData[weightPicker.selectedRow(inComponent: 0)]
            parent.weight = self.weight
        }
        
        
        performSegue(withIdentifier: "saveNewDog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveNewDog"{
            let destination = segue.destination as! SavingViewController
            let parent = self.parent as! NewDogPageViewController
            destination.birthday = parent.birthday
            destination.breed = parent.breed
            destination.gender = parent.gender
            destination.photo = parent.photo
            destination.name = parent.name
            destination.weight = parent.weight
        }
    }
    
    var pickerData = [String]()
    var weight: String?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.weight = pickerData[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1..<101{
            pickerData.append(String(i))
        }
        self.weightPicker.dataSource = self
        self.weightPicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
