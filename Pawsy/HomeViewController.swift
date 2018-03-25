//
//  HomeViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 2/21/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Quickblox
import Firebase
import Cloudinary
import Quickblox


class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func parkButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    @IBAction func inboxButton(_ sender: UIButton) {
        var chatDialog: QBChatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.publicGroup)
        QBRequest.createDialog(chatDialog, successBlock: { (response, dialog) in

        }) { (response) in
            if response.error != nil{
                print(response.error.debugDescription)
            }
        }
        performSegue(withIdentifier: "goToInbox", sender: self)
    }
    @IBAction func friendsButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToFriends", sender: self)
    }
    
    @IBAction func profileButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        currentDog.sharedInstance.currentReference = nil
        currentDog.sharedInstance.imageURL = nil
        currentDog.sharedInstance.image = nil
        currentDog.sharedInstance.name = nil
        currentDog.sharedInstance.documentID = nil
        currentDog.sharedInstance.quickBloxID = nil
        currentDog.sharedInstance.quickPass = nil
        currentDog.sharedInstance.quickUser = nil
        self.performSegue(withIdentifier: "goToLaunchAfterSignOut", sender: self)
    }
    
    @IBAction func switchDogs(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "selectDogFromHome", sender: self)
    }

    func signIntoChat(){

    }

    func signIntoQuickBlox(){
        let dog = currentDog.sharedInstance
        QBRequest.logIn(withUserLogin: dog.documentID, password: Auth.auth().currentUser!.uid, successBlock: { (response, quser) in
            if quser != nil{
                print("successfully logged In")
                QBChat.instance.connect(with: quser, completion: { (error2) in
                    if error2 != nil{
                        print ("could not login to chat")
                    }
                })

            }
        }) { (response) in
            if response.error != nil{
                print("there was a login error")
            }
        }
    }
    
    override func viewDidLoad() {
        currentDog.sharedInstance.currentReference!.getDocument(completion: { (snapshot, error) in
            if snapshot != nil{
                let name = snapshot?.data()!["name"] as? String
                DispatchQueue.main.async {
                    self.nameLabel.text = name
                    self.signIntoQuickBlox()
                }
            }
        })
        print(currentDog.sharedInstance.currentReference?.documentID)
    }
}


