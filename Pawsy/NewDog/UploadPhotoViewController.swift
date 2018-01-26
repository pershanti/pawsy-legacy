//
//  UploadPhotoViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import CoreImage

class UploadPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photo: UIImage?
    var photoPicker: UIImagePickerController = UIImagePickerController()

    @IBAction func takePhoto(_ sender: UIButton) {
        photoPicker.sourceType = UIImagePickerControllerSourceType.camera
        present(photoPicker, animated: true, completion: nil)
    
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        photoPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.photo = image
        let parent = self.parent as! NewDogPageViewController
        parent.photo = self.photo
        parent.setViewControllers([parent.pages[2]], direction: .forward, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDone" {
            let destination = segue.destination as! PhotoViewController
            destination.image = self.photo!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
