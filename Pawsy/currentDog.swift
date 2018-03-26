//
//  currentDog.swift
//  
//
//  Created by Shantini Persaud on 3/24/18.
//

import Foundation
import Firebase

class currentDog{
    static let sharedInstance = currentDog()
    var currentReference: DocumentReference?
    var imageURL: String?
    var image: UIImage?
    var documentID: String?
    var name: String?
    private init(){
    }

}
