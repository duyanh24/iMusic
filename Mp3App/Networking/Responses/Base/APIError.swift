//
//  APIError.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import FirebaseAuth

struct APIError: Error, Codable {
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    init(statusCode: Int?, statusMessage: String?) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
    
    init(authErrorCode: AuthErrorCode) {
        switch authErrorCode.rawValue {
        case AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue:
            self.statusCode = AuthencationStatusCode.FIRAuthErrorCodeWrongPassword.rawValue
            self.statusMessage = ErrorMessage.wrongPassword
        case AuthencationStatusCode.FIRAuthErrorCodeUserNotFound.rawValue:
            self.statusCode = AuthencationStatusCode.FIRAuthErrorCodeUserNotFound.rawValue
            self.statusMessage = ErrorMessage.wrongEmail
        default:
            self.statusMessage = ErrorMessage.unknownError
        }
    }
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(statusMessage ?? ErrorMessage.errorOccur, comment: "")
    }
}
