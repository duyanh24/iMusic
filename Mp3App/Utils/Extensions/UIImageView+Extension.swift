//
//  UIImageView+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 10/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func blurImage(imageDefault: UIImage?) {
        guard let currentFilter = CIFilter(name: "CIGaussianBlur"),
            let cropFilter = CIFilter(name: "CICrop"),
            let image = imageDefault ?? image
        else {
            return
        }
        
        let context = CIContext(options: nil)

        guard let beginImage = CIImage(image: image) else {
            return
        }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(50, forKey: kCIInputRadiusKey)
        
        cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")

        guard let output = cropFilter.outputImage,
            let cgimg = context.createCGImage(output, from: output.extent)
        else {
            return
        }
        
        let processedImage = UIImage(cgImage: cgimg)
        self.image = processedImage
    }
}
