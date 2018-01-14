//
//  NameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class NameViewController: UIViewController {

    @IBOutlet weak var nameBox: UITextField!
    @IBAction func nextButton(_ sender: UIButton) {
        
        self.name = nameBox.text
        let parent = self.parent as! NewDogPageViewController
        parent.name = name
        parent.setViewControllers([parent.pages[1]], direction: .forward, animated: true, completion: nil)
    }
    
    let user = Auth.auth().currentUser!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
