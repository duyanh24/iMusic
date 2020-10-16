//
//  URLds.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation

struct APIURL {
    static let baseURLv2 = "https://api-v2.soundcloud.com"
    static let baseURLv1 = "https://api.soundcloud.com"
}

struct Constants {
    static let APIKey = "a25e51780f7f86af0afa91f241d091f8"
}

enum ErrorMessage {
    static let notFound = "Not found"
    static let badRequest = "Bad request"
    static let serverError = "Server error"
    static let errorOccur = "An error occurs"
    static let authenticalError = "Lỗi xác thực tài khoản"
    static let wrongPassword = "Mật khẩu không chính xác"
    static let invalidEmail = "Email không đúng định dạng"
    static let wrongEmail = "Email không chính xác"
    static let unknownError = "Lỗi không xác định"
    static let validateAccount = "Email và mật khẩu phải lớn hơn 6 ký tự"
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

enum APIParameterKey: String {
    case kind = "kind"
    case limit = "limit"
    case offset = "offset"
    case clientId = "client_id"
    case top = "top"
    case genre = "genre"
}

enum TrackGenre: String {
    case electronic = "soundcloud:genres:electronic"
    case hiphop = "soundcloud:genres:hiphoprap"
    case classical = "soundcloud:genres:classical"
    case rock = "soundcloud:genres:rock"
}

enum ImageSize: String {
    case large = "-large."
    case crop = "-crop."
    case medium = "-t300x300."
    case small = "-small."
    case tiny = "-tiny."
}

enum FirebaseProperty: String {
    case users = "users"
    case username = "username"
    case password = "password"
    case id = "id"
}

enum AccountDefaultKey: String {
    case userSessionKey = "com.save.usersession"
    case idkey = "id"
    case emailKey = "email"
    case passwordKey = "password"
}
