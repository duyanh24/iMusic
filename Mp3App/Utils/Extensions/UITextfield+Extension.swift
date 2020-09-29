//
//  UITextfield+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit

extension UITextField{
    func setLeftImage(imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height))
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
}

extension UITextField {
    func fixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }
}
