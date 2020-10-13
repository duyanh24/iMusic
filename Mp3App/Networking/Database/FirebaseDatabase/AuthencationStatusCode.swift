//
//  AuthencationStatusCode.swift
//  Mp3App
//
//  Created by Apple on 10/11/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

enum AuthencationStatusCode: Int {
    case FIRAuthErrorCodeUserDisabled = 17005
    case FIRAuthErrorCodeInvalidEmail = 17008
    case FIRAuthErrorCodeWrongPassword = 17009
    case FIRAuthErrorCodeUserNotFound = 17011
}
