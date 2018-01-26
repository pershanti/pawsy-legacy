//
//  HomeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/11/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController {
    
    @IBAction func addNewDog(_ sender: UIButton) {
        performSegue(withIdentifier: "addNewDog", sender: nil)
    }
    
    func checkForDogs(){
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
