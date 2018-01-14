//
//  PhotoViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/11/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBAction func doneButton(_ sender: UIButton) {
    let parent = self.parent as! NewDogPageViewController
    parent.setViewControllers([parent.pages[3]], direction: .forward, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
