//
//  InputValidateHelper.swift
//  Mp3App
//
//  Created by AnhLD on 10/16/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

enum InputValidateType {
    case email
    case password
}

class InputValidateHelper {
    static func validate(type: InputValidateType, input: String) -> Bool {
        switch type {
        case .email:
            return validateEmail(email: input)
        case .password:
            return validatePassword(password: input)
        }
    }
    
    static func validate(type: InputValidateType, input: String?) -> String {
        guard let input = input else {
            return ErrorMessage.unknownError
        }
        switch type {
        case .email:
            return validateEmail(email: input)
        case .password:
            return validatePassword(password: input)
        }
    }
    
    static func validatePassword(password: String) -> Bool {
        return password.count >= Constants.passwordMinLength && password.count <= Constants.passwordMaxLength
    }
    
    static func validatePassword(password: String) -> String {
        if password.count >= Constants.passwordMinLength && password.count <= Constants.passwordMaxLength {
            return ""
        } else {
            return String(format: ErrorMessage.passwordNotInRangeError, Constants.passwordMinLength, Constants.passwordMaxLength)
        }
    }
    
    static func validateEmail(email: String) -> Bool {
        return NSPredicate(format: Strings.emailFormat, Strings.regularExpressionForEmail).evaluate(with: email)
    }
    
    static func validateEmail(email: String) -> String {
        let regularExpressionForEmail = Strings.regularExpressionForEmail
        let isValid = NSPredicate(format: Strings.emailFormat, regularExpressionForEmail).evaluate(with: email)
        if isValid {
            return ""
        } else {
            return ErrorMessage.invalidEmail
        }
    }
}
