//
//  DogParkViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 3/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class DogParkViewController: UIViewController {

    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
