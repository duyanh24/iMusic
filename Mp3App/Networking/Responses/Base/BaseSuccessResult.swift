//
//  BaseSuccessResult.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct BaseSuccessResult: Error, Codable {
    var success: Bool?
    var status_code: Int?
    var status_message: String?
}
