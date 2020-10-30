//
//  SearchService.swift
//  Mp3App
//
//  Created by AnhLD on 10/30/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasSearchService {
    var searchService: SearchService { get }
}

struct SearchService {
    func searchTrack(keyWord: String) -> Observable<SearchRespone> {
        return HostAPIClient.performApiNetworkCall(router: .searchTrack(keyWord: keyWord), type: SearchRespone.self)
    }
}
