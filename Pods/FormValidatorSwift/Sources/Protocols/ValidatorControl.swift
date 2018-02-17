//
//  ValidatorControl.swift
//  FormValidatorSwift
//
//  Created by Aaron McTavish on 13/01/2016.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation


public protocol ValidatorControlDelegate: class {
    
    func validatorControlDidChange(_ validatorControl: ValidatorControl)
    func validatorControl(_ validatorControl: ValidatorControl, changedValidState validState: Bool)
    func validatorControl(_ validatorControl: ValidatorControl, violatedConditions conditions: [Condition])
    
}


public protocol ValidatorControl: class, Validatable {
    
    var isValid: Bool { get }
    var shouldAllowViolation: Bool { get set }
    var validateOnFocusLossOnly: Bool { get set }
    weak var validatorDelegate: ValidatorControlDelegate? { get }
    
}


public extension ValidatorControl {
    
    var isValid: Bool {
        return validator.checkConditions(validatableText) == nil
    }
    
}
