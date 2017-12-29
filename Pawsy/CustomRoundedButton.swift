//
//  CustomRoundedButton.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/28/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit

class CustomRoundedButton: UIButton {
    
    func setUp() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.purple
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
}
