//
//  WKWebview+Extension.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    class func clean() {
        URLCache.shared.removeAllCachedResponses()
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
    }
}
