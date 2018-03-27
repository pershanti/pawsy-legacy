//
//  IntroViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
   
    @IBOutlet weak var introImageView: UIImageView!
    
    @IBAction func next(_ sender: UIButton) {
  
    self.performSegue(withIdentifier: "goToLocation", sender: nil)
    
    }
    
    override func viewDidLoad() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
