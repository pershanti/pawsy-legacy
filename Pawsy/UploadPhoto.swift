//
//  UploadPhoto.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie

class UploadPhoto: UIViewController {

    @IBOutlet weak var lottieUpload: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animationView = LOTAnimationView(name: "camera")
        animationView.center = self.lottieUpload.center
        animationView.loopAnimation = true
        self.lottieUpload.addSubview(animationView)
        animationView.play()
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
