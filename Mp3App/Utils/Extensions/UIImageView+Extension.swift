//
//  UIImageView+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 10/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

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
    
    func setImage(stringURL: String) {
        self.sd_imageTransition = .fade
        self.sd_setImage(with: URL(string: stringURL))
    }
    
    func rotate(duration: Double = 15) {
        if layer.animation(forKey: Strings.rotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: Strings.rotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: Strings.rotationAnimationKey) != nil {
            layer.removeAnimation(forKey: Strings.rotationAnimationKey)
        }
    }
}
