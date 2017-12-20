//
//  ImageUploadViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/15/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase


class ImageUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let storage = Storage.storage()
    let currentUserID = Auth.auth().currentUser!.uid
    let currentDog = Firestore.firestore().collection("users").document(currentUserID).collection("dogs")
    
    var imagePicker =  UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let storageRef = storage.reference()
        let imagePath = info["UIImagePickerControllerReferenceURL"]
        
        
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true)
        
        
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
         self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
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
