//
//  ArrayHelper.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

class ArrayHelper {
    static func combine<T>(arrays:[[T]]) -> [T] {
        let maxCount = arrays.reduce(0) { max($0, $1.count) }
        var result = [T]()

        for i in 0..<maxCount {
            for array in arrays {
                if i < array.count {
                    result.append(array[i])
                }
            }
        }
        return result
    }
}
