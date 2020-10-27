//
//  Converter.swift
//  Mp3App
//
//  Created by Apple on 10/6/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class Converter {
    static func changeImageURLSize(imgURL: String, desireSize: ImageSize) -> String {
        var originalSize = ImageSize.large
        if imgURL.contains(ImageSize.crop.rawValue) {
            originalSize = ImageSize.crop
        } else if imgURL.contains(ImageSize.medium.rawValue) {
            originalSize = ImageSize.medium
        } else if imgURL.contains(ImageSize.small.rawValue) {
            originalSize = ImageSize.small
        } else if imgURL.contains(ImageSize.tiny.rawValue) {
            originalSize = ImageSize.tiny
        }
        return imgURL.replacingOccurrences(of: originalSize.rawValue, with: desireSize.rawValue)
    }
    
    static func stringFromTimeInterval(interval: Int) -> String {
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
