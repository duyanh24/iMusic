//
//  Converter.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class Converter {
    static func convertLargeImgtoCrop(imgUrl: String) -> String {
        return imgUrl.replacingOccurrences(of: "-large.", with: "-crop.")
    }
}
