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
        self.introImages.append(UIImage(named:"heyDog")!)
        self.introImages.append(UIImage(named:"welcomeToPawsy")!)
        self.introImages.append(UIImage(named:"parkr+matchr")!)
        self.introImages.append(UIImage(named:"parkrIntro")!)
        self.introImages.append(UIImage(named:"matchrIntro")!)
        self.introImages.append(UIImage(named:"getHooman")!)
        self.introImageView.contentMode = .scaleAspectFill
        self.introImageView.image = UIImage(named: "heyDog")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
