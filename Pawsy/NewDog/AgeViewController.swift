//
//  AgeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class AgeViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        birthday = datePicker.date
        let parent = self.parent as! NewDogPageViewController
        parent.birthday = birthday
        parent.setViewControllers([parent.pages[6]], direction: .forward, animated: true, completion: nil)
    }
    
    var birthday: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.datePickerMode = UIDatePickerMode.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
