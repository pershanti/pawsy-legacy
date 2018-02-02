//
//  Snoot.swift
//  Alamofire
//
//  Created by Shantini Vyas on 1/31/18.
//

import UIKit

class Snoot: UIViewController {

    @IBAction func nextButton(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToLocation", sender: self)
    
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
