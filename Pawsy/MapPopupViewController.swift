//
//  MapPopupViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/20/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class MapPopupViewController: UIViewController {

    var park: Park?

    @IBAction func goToParkPageButton(_ sender: UIButton) {
        let presenter = self.presentingViewController as! MapViewController
        presenter.performSegue(withIdentifier: "goToParkPage", sender: nil)
    }

    @IBAction func dismissButton(_ sender: UIButton) {

    }

    @IBOutlet weak var parkNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parkNameLabel.text = park!.name

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
