//
//  SavingViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/29/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Cloudinary
import Firebase
import ChameleonFramework
import NVActivityIndicatorView

class SavingViewController: UIViewController {
    
    var delegate: SavingViewControllerDelegate?
    var cloudinary: CLDCloudinary?
    var dogImage: UIImage?
    var dogID: String?
    var dogDoc: DocumentReference?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    


    func uploadToCloudinary(photo: UIImage, dogID: String, document: DocumentReference) {
        
        let uploadData = UIImageJPEGRepresentation(photo, 1)
        _ = self.cloudinary?.createUploader().upload(data: uploadData!, uploadPreset: "pawsyDogPic", params: nil, progress: {({ (progress) in
            print(progress)
        })}(), completionHandler: { (result, error) in
            if error != nil{
                print(error!)
            }
            else{
                document.updateData(["photo": result?.resultJson["url"] as Any])
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Turquoise")
        let frame = CGRect(x: (view.frame.width-200)/2, y: (view.frame.height-200)/2, width: 200, height: 200)
        let animationView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballSpinFadeLoader, color: FlatWhite(), padding: nil)
        self.view.addSubview(animationView)
        animationView.startAnimating()
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        self.uploadToCloudinary(photo: self.dogImage!, dogID: self.dogID!, document: self.dogDoc!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
