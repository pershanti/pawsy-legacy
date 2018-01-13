//
//  AgeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class AgeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData: [[String]] = [
    ["0 years",
     "1 year",
     "2 years",
     "3 years",
     "4 years",
     "5 years",
     "6 years",
     "7 years",
     "8 years",
     "9 years",
     "10 years",
     "11 years",
     "12 years",
     "13 years",
     "14 years",
     "15 years",
     "16 years",
     "17 years",
     "18 years",
     "19 years",
     "20 years"],
    
    [ "0 months",
      "1 month",
      "2 months",
      "3 months",
      "4 months",
      "5 months",
      "6 months",
      "7 months",
      "8 months",
      "9 months",
      "10 months",
      "11 months"
    ]
]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    
    

    @IBOutlet weak var agePicker: UIPickerView!
    @IBAction func nextButton(_ sender: UIButton) {
        let parent = self.parent as! NewDogPageViewController
        parent.setViewControllers([parent.pages[2]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.agePicker.dataSource = self
        self.agePicker.delegate = self
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
