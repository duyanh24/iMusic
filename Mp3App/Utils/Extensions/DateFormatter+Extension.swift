//
//  DateFormatter+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String, localeIdentifier: String = Constants.defaultLocaleIdentifier) {
        self.init()
        self.calendar = Calendar(identifier: .gregorian)
        self.locale = Locale(identifier: localeIdentifier)
        self.dateFormat = dateFormat
    }
}
