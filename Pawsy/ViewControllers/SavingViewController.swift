//
//  SavingViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/29/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie
import Cloudinary
import Firebase

class SavingViewController: UIViewController {
    
    var delegate: SavingViewControllerDelegate?
    var cloudinary: CLDCloudinary?
    var dogImage: UIImage?
    var dogID: String?
    var dogDoc: DocumentReference?
    var animationView: LOTAnimationView?
    
    @IBOutlet weak var lottieView: UIView!
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")


    func uploadToCloudinary(photo: UIImage, dogID: String, document: DocumentReference) {
        self.animationView = LOTAnimationView(name: "materialLoading")
        self.animationView!.loopAnimation = true
        self.lottieView.addSubview(self.animationView!)
        self.animationView!.play { (finished) in
            
        }
        let uploadData = UIImageJPEGRepresentation(photo, 1)
        _ = self.cloudinary?.createUploader().upload(data: uploadData!, uploadPreset: "pawsyDogPic", params: nil, progress: {({ (progress) in
            print(progress)
        })}(), completionHandler: { (result, error) in
            if error != nil{
                print(error!)
            }
            else{
                document.updateData(["photo": result?.resultJson["url"]])
                self.delegate!.allDone(self)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        self.uploadToCloudinary(photo: self.dogImage!, dogID: self.dogID!, document: self.dogDoc!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
