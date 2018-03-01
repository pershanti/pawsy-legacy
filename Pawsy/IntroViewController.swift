//
//  IntroViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
   
    var currentIntro: Int = 0
    var introImages = [UIImage]()

    @IBOutlet weak var introImageView: UIImageView!
    
    @IBAction func next(_ sender: UIButton) {
        if currentIntro < introImages.count-1{
            currentIntro += 1
            introImageView.image = introImages[currentIntro]
        }
        else{
            self.performSegue(withIdentifier: "goToLocation", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        self.introImages.append(UIImage(named:"Hey")!)
        self.introImages.append(UIImage(named:"Hookup")!)
        self.introImages.append(UIImage(named:"Park")!)
        self.introImages.append(UIImage(named:"Human")!)
        
        self.introImageView.contentMode = .scaleAspectFill
        self.introImageView.image = UIImage(named: "Hey")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
