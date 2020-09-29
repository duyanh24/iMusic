//
//  Codable+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

extension Encodable {
    func encodePlist() -> Data? {
        do {
            let encodedValue = try PropertyListEncoder().encode(self)
            return encodedValue
        } catch {
            return nil
        }
    }
}

extension Data {
    func decodeFromPlist<T: Decodable>() -> T? {
        do {
            let decodedValue = try PropertyListDecoder().decode(T.self, from: self)
            return decodedValue
        } catch {
            return nil
        }
    }
}
