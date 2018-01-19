//
//  SavingViewController.swift
//  Alamofire
//
//  Created by Shantini Vyas on 1/14/18.
//


import UIKit
import Cloudinary
import Firebase
import FirebaseAuthUI
import ChameleonFramework
import Lottie

class SavingViewController: UIViewController {
    
    var user: User?
    var name: String?
    var gender: String?
    var birthday: Date?
    var weight: String?
    var photo: UIImage?
    var breed: String?
    
    var cloudinary: CLDCloudinary?
    var dogID: String?
    var dogDoc: DocumentReference?
    let config = CLDConfiguration(cloudinaryUrl: "cloudinary://748252232564561:bPdJ9BFNE4oSFYDVlZi5pEfn-Qk@pawsy")
    var animationView: LOTAnimationView?
    

    func uploadToCloudinary(photo: UIImage, dogID: String, document: DocumentReference) {
        
        let uploadData = UIImageJPEGRepresentation(photo, 1)
        _ = self.cloudinary?.createUploader().upload(data: uploadData!, uploadPreset: "pawsyDogPic", params: nil, progress: {({ (progress) in
            print(progress)
        })}(), completionHandler: { (result, error) in
            if error != nil{
                print(error!)
            }
            else{
                self.animationView!.stop()
                let sceneModel = LOTComposition(name: "favourite_app_icon")
                self.animationView!.sceneModel = sceneModel
                self.animationView!.play(completion: { (bool) in
                    document.updateData(["photo": result?.resultJson["url"] as Any])
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }
        })
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
        self.user = Auth.auth().currentUser!
        let db = Firestore.firestore()
        dogDoc = db.collection("users").document(self.user!.uid).collection("dogs").addDocument(data: ["name": self.name!,
            "gender": self.gender!,
            "birthday": self.birthday!,
            "weight": self.weight!,
            "breed": self.breed!], completion: { (error) in
                if error != nil{
                    print (error!)
                }
                else {
                    print("upload Okay!!!!!!!")
                }
        })
        dogID = self.user!.uid + "-" + name!
        self.cloudinary = CLDCloudinary(configuration: self.config!)
        self.uploadToCloudinary(photo: self.photo!, dogID: self.dogID!, document: self.dogDoc!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

