//
//  UploadPhoto.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Lottie
import CoreData

class GetPhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photoUpload: UIImagePickerController = UIImagePickerController()
    var alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
    var user =  [LocalUser]()

    @IBOutlet weak var lottieUpload: UIView!
    
    @IBAction func photoTap(_ sender: UITapGestureRecognizer) {
        guard sender.view != nil else { return }
        
        if sender.state == .ended{
            self.present(alert, animated: true, completion: nil)
        } 
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFinish", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        save(photo: image)
    }
    
    func fetchUser(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "LocalUser")
        //3
        do {
            user = try managedContext.fetch(fetchRequest) as! [LocalUser]
            print(user)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(photo: UIImage){
        let imageData = UIImageJPEGRepresentation(photo, 1)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "LocalUser",
                                       in: managedContext)!
        let person = self.user[0]
        // 3
        person.setValue(imageData, forKeyPath: "photo")
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setUpAlertController(){
        self.photoUpload.delegate = self
        self.alert.addAction(UIAlertAction(title: "Take New Photo", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.photoUpload.sourceType = .camera
            self.present(self.photoUpload, animated: true, completion: nil)
        }))
        self.alert.addAction(UIAlertAction(title: "Select From Photo Library", style: UIAlertActionStyle.default, handler: { (alertAction) in
            self.photoUpload.sourceType = .photoLibrary
            self.present(self.photoUpload, animated: true, completion: nil)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setUpAlertController()
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
    }

}
