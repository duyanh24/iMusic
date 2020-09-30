//
//  APIError.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct APIError: Error, Codable {
    var success: Bool?
    var status_code: Int?
    var status_message: String?
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(status_message ?? ErrorMessage.errorOccur, comment: "")
    }
}
