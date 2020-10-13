//
//  APIClient.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

class HostAPIClient {
    static func performApiNetworkCall<T: Codable>(router: APIRouter, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            NetworkManager.apiProvider.request(router) { result in
                switch result {
                case .failure(let error):
                    if let data = error.response?.data {
                        do {
                            let response = try JSONDecoder().decode(APIError.self, from: data)
                            observer.onError(response)
                        } catch let error {
                            print(error)
                            observer.onError(APIError(statusCode: nil, statusMessage: ErrorMessage.errorOccur))
                        }
                    } else {
                        let statusCode = error.response?.statusCode
                        switch statusCode {
                        case HTTPStatusCodes.InternalServerError.rawValue:
                            observer.onError(APIError(statusCode: statusCode, statusMessage: ErrorMessage.serverError))
                        case HTTPStatusCodes.NotFound.rawValue:
                            observer.onError(APIError(statusCode: statusCode, statusMessage: ErrorMessage.notFound))
                        case HTTPStatusCodes.Unauthorized.rawValue:
                            observer.onError(APIError(statusCode: statusCode, statusMessage: ErrorMessage.authenticalError))
                        case HTTPStatusCodes.BadRequest.rawValue:
                            observer.onError(APIError(statusCode: statusCode, statusMessage: ErrorMessage.badRequest))
                        default:
                            observer.onError(APIError(statusCode: statusCode, statusMessage: ErrorMessage.errorOccur))
                        }
                    }
            
                    observer.onCompleted()
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == HTTPStatusCodes.OK.rawValue || statusCode == HTTPStatusCodes.Created.rawValue {
                        let data = response.data
                        do {
                            let object = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(object)
                        } catch let error {
                            print(error)
                            observer.onError(error)
                        }
                    } else {
                        let data = response.data
                        do {
                            let error = try JSONDecoder().decode(APIError.self, from: data)
                            observer.onError(error)
                        } catch let error {
                            print(error)
                            observer.onError(error)
                        }
                    }
                    
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
