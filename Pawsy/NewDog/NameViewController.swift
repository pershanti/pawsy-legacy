//
//  NameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 1/12/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class NameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameBox: UITextField!
    @IBAction func nextButton(_ sender: UIButton) {
        
        self.name = nameBox.text
        let parent = self.parent as! NewDogPageViewController
        parent.name = name
        parent.setViewControllers([parent.pages[1]], direction: .forward, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameBox.resignFirstResponder()
        return true
    }
    
    
    let user = Auth.auth().currentUser!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension UIViewController
{
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

