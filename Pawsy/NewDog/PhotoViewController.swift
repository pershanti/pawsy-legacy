//
//  PhotoViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/11/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func doneButton(_ sender: UIButton) {
        let parent = self.parent as! NewDogPageViewController
        self.image = parent.photo
        parent.setViewControllers([parent.pages[3]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let parent = self.parent as! NewDogPageViewController
        self.image = parent.photo
        self.imageView.image = self.image
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.center = view.center
        imageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
