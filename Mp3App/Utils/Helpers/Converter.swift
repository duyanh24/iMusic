//
//  Converter.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class Converter {
    static func changeImageURLSize(imgURL: String, originalSize: ImageSize, desireSize: ImageSize) -> String {
        return imgURL.replacingOccurrences(of: originalSize.rawValue, with: desireSize.rawValue)
    }
}
