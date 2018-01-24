//
//  SavingViewController.swift
//  Alamofire
//
//  Created by Shantini Vyas on 1/14/18.
//


import UIKit
import Cloudinary
import Lottie

class SavingViewController: UIViewController {
    
    var name: String?
    var gender: String?
    var birthday: Date?
    var weight: String?
    var photo: UIImage?
    var breed: String?
    var cloudinary: CLDCloudinary?
    var dogID: String?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    var animationView: LOTAnimationView?

    func uploadToCloudinary(photo: UIImage, dogID: String) {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let frame = CGRect(x: (view.frame.width-200)/2, y: (view.frame.height-200)/2, width: 200, height: 200)
        let scenemodel = LOTComposition(name: "dogrun")
        animationView = LOTAnimationView(model: scenemodel, in: nil)
        animationView!.loopAnimation = true
        animationView!.frame = frame
        self.view.addSubview(animationView!)
        animationView!.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

