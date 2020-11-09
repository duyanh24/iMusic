//
//  UserResultViewModel.swift
//  Mp3App
//
//  Created by Apple on 11/5/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserResultViewModel: ServicesViewModel {
    var services: SearchServices!
    private let errorTracker = ErrorTracker()
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let dataSource = input.searchUser.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchUserRespone> in
            guard let self = self else {
                return .empty()
            }
            if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
                return .empty()
            }
            return self.searchUsers(keyword: keyword)
        }.map { searchUserRespone -> [UserSectionModel] in
            return [UserSectionModel(model: "", items: searchUserRespone.users ?? [])]
        }.trackActivity(activityIndicator)
        
        return Output(dataSource: dataSource, activityIndicator: activityIndicator.asObservable())
    }
}

extension UserResultViewModel {
    struct Input {
        var searchUser: Observable<String>
    }
    
    struct Output {
        var dataSource: Observable<[UserSectionModel]>
        var activityIndicator: Observable<Bool>
    }
}

extension UserResultViewModel {
    private func searchUsers(keyword: String) -> Observable<SearchUserRespone> {
        return services.searchService.searchUsers(keyword: keyword).trackError(errorTracker)
    }
}
