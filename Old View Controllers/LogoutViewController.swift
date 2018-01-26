//
//  LogoutViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/29/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI


class LogoutViewController: UIViewController {
    
    var authUI: FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try self.authUI!.signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch {
            print("error")
        }
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
