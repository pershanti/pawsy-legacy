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
        parent.setViewControllers([parent.pages[3]], direction: .forward, animated: true, completion: nil)
    }
    
    var pickerData = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
