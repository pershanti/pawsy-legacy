//
//  PetNameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/14/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase

class OnboardingViewController: UIViewController, ImageUploadViewControllerDelegate, PlayStylePageViewControllerDelegate, StatsViewControllerDelegate {
    
    let user = Auth.auth().currentUser!
    var newDog: DataModel?;

    @IBOutlet weak var nameBox: UITextField!
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        self.createNewDog()
    }
    
    func didGetPhoto(_ controller: ImageUploadViewController, imagePath: URL) {
        <#code#>
    }
    
    func didGetPlayStyle(_ controller: PlayStylePageViewController, energyLevel: Int, dogFeelings: Int, humanFeelings: Int, roughness: Int, ball: Int, playScene: Int, dogSizePreference: Int, lookingFor: Int) {
        <#code#>
    }
    
    func didSubmitStats(_ controller: StatsViewController, age: Int, vaccine: Bool, breed: String) {
        <#code#>
    }
    
    
    
    
    
    func createNewDog(){
        self.newDog = DataModel(self.nameBox.text)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
