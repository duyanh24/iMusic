//
//  URLds.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct APIURL {
    static let baseURL = "https://thanhhvt7196.xyz"
    static let imageBaseURL = "https://image.thanhhvt7196.xyz"
    static let youtubeImageURL = "https://img.youtube.com/vi/%@/hqdefault.jpg"
}

struct Constants {
    static let APIKey = ""
    static let defaultLocaleIdentifier = "en_US_POSIX"
    
    static let passwordMinLength = 4
    static let passwordMaxlength = 16
}

enum ErrorMessage {
    static let notFound = "Not found"
    static let authenticalError = "Authentical error"
    static let badRequest = "Bad request"
    static let serverError = "Server error"
    static let errorOccur = "An error occurs"
}

struct APIConstants {
    static let DEFAULT_TIMEOUT_INTERVAL: TimeInterval = 60.0
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case ifModifiedSince = "If-Modified-Since"
    case userAgent = "User-Agent"
    case cookie = "Cookie"
    case deviceGuid = "X-DEVICE-GUID"
    case notificationId = "X-Push-Notify"
    case urlScheme = "X-Url-Scheme"
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
    case password = "X- -Password"
    case html = "text/html"
}
