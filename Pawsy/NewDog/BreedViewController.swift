//
//  BreedViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/13/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class BreedViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var breedPicker: UIPickerView!
    
    @IBAction func nextButton(_ sender: Any) {
        let parent = self.parent as! NewDogPageViewController
        parent.breed = self.breed
        parent.setViewControllers([parent.pages[4]], direction: .forward, animated: true, completion: nil)
    }
    
    var breedClass = breeds()
    var breedlist: [String]?
    var breed: String?
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breedlist!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breedlist?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.breed = breedlist?[row]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedPicker.dataSource = self
        breedPicker.delegate = self
        breedlist = breedClass.breeds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
}
