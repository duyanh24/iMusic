//
//  JSONHelper.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class JSONHelper {
    static func dataFromFile(path: String) -> Data? {
        if let path = Bundle.main.path(forResource: path, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch let error {
                print("parse error: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("Invalid filename/path.")
            return nil
        }
    }
}
