//
//  NameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var nameBox: UITextField!
    @IBAction func nextButton(_ sender: UIButton) {
        let parent = self.parent as! NewDogPageViewController
        parent.setViewControllers([parent.pages[1]], direction: .forward, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
