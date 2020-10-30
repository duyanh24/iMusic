//
//  APIProvider.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import Moya

enum APIRouter {
    case getPopularAlbums(kind: APIParameterKey, limit: Int, offset: Int)
    case getChartTrack(kind: APIParameterKey, limit: Int, offset: Int)
    case getAlbums(kind: APIParameterKey, genre: TrackGenre, limit: Int, offset: Int)
    case getPopularUser(limit: Int, offset: Int)
    case getTrack(trackId: String)
    case searchTrack(keyWord: String)
}

extension APIRouter: TargetType {
    var baseURL: URL {
        switch self {
        case .getPopularUser:
            return URL(string: APIURL.baseURLv1)!
        default:
            return URL(string: APIURL.baseURLv2)!
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        var bodyParameters: [String: Any] = [:]
        var encoding: ParameterEncoding
        switch self {
        case .getPopularAlbums(let kind, let limit, let offset):
            bodyParameters = [APIParameterKey.kind.rawValue: kind.rawValue,
                              APIParameterKey.limit.rawValue: limit,
                              APIParameterKey.offset.rawValue: offset,
                              APIParameterKey.clientId.rawValue: Constants.APIKey]
            encoding = URLEncoding.default
            return .requestParameters(parameters: bodyParameters, encoding: encoding)
            
        case .getChartTrack(let kind, let limit, let offset):
            bodyParameters = [APIParameterKey.kind.rawValue: kind.rawValue,
                          APIParameterKey.limit.rawValue: limit,
                          APIParameterKey.offset.rawValue: offset,
                          APIParameterKey.clientId.rawValue: Constants.APIKey]
            encoding = URLEncoding.default
        return .requestParameters(parameters: bodyParameters, encoding: encoding)
        
        case .getAlbums(let kind, let genre, let limit, let offset):
            bodyParameters = [APIParameterKey.kind.rawValue: kind.rawValue,
                              APIParameterKey.limit.rawValue: limit,
                              APIParameterKey.offset.rawValue: offset,
                              APIParameterKey.clientId.rawValue: Constants.APIKey,
                              APIParameterKey.genre.rawValue: genre.rawValue]
            encoding = URLEncoding.default
            return .requestParameters(parameters: bodyParameters, encoding: encoding)
        
        case .getPopularUser(let limit, let offset):
            bodyParameters = [APIParameterKey.limit.rawValue: limit,
                              APIParameterKey.offset.rawValue: offset,
                              APIParameterKey.clientId.rawValue: Constants.APIKey]
            encoding = URLEncoding.default
            return .requestParameters(parameters: bodyParameters, encoding: encoding)
        case .getTrack:
            return .requestPlain
        case .searchTrack(let keyWord):
            bodyParameters = [APIParameterKey.keyWord.rawValue: keyWord,
                              APIParameterKey.clientId.rawValue: Constants.APIKey]
            encoding = URLEncoding.default
            return .requestParameters(parameters: bodyParameters, encoding: encoding)
        }
    }
    
    var headers: [String : String]? {
        return [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue
        ]
    }
    
    var path: String {
        switch self {
        case .getPopularAlbums, .getChartTrack, .getAlbums:
            return "/charts"
        case .getPopularUser:
            return "/users"
        case .getTrack(let trackId):
            return "/tracks/\(trackId)"
        case .searchTrack:
            return "/search/tracks"
        }
    }
}
