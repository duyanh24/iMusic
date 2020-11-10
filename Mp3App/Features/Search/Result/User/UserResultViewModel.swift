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
    private var offset = 0
    private var maxResult = 60
    private var keyword = ""
    private let dataSource = BehaviorRelay<[UserSectionModel]>(value: [])
    private let isLoadMoreEnabled = BehaviorSubject<Bool>(value: true)
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let loadData = input.searchUser.distinctUntilChanged().flatMapLatest { [weak self] keyword -> Observable<SearchUserRespone> in
            guard let self = self else {
                return .empty()
            }
            if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
                return .empty()
            }
            self.keyword = keyword
            self.offset = 0
            self.isLoadMoreEnabled.onNext(true)
            return self.searchUsers(keyword: keyword).trackActivity(activityIndicator)
        }.map { searchUserRespone -> [UserSectionModel] in
            return [UserSectionModel(model: "", items: searchUserRespone.users ?? [])]
        }.do(onNext: { [weak self] userSectionModel in
            self?.dataSource.accept(userSectionModel)
        }).mapToVoid()
        
        let loadMoreData = input.loadMore
            .skip(1)
            .flatMapLatest { [weak self] _ -> Observable<SearchUserRespone> in
                guard let self = self else {
                    return .empty()
                }
                self.offset += 15
                if self.offset > self.maxResult {
                    self.isLoadMoreEnabled.onNext(false)
                }
                return self.searchUsers(keyword: self.keyword, offset: self.offset).trackActivity(activityIndicator)
        }.map { searchRespone -> [UserSectionModel] in
            let users = (self.dataSource.value.first?.items ?? []) + (searchRespone.users ?? [])
            return [UserSectionModel(model: "", items: users)]
        }.do(onNext: { [weak self] userSectionModel in
            self?.dataSource.accept(userSectionModel)
        }).mapToVoid()
        
        return Output(dataSource: dataSource.asObservable(), activityIndicator: activityIndicator.asObservable(), loadData: loadData, loadMoreData: loadMoreData, isLoadMoreEnabled: isLoadMoreEnabled)
    }
}

extension UserResultViewModel {
    struct Input {
        var searchUser: Observable<String>
        var loadMore: Observable<Void>
    }
    
    struct Output {
        var dataSource: Observable<[UserSectionModel]>
        var activityIndicator: Observable<Bool>
        var loadData: Observable<Void>
        var loadMoreData: Observable<Void>
        var isLoadMoreEnabled: Observable<Bool>
    }
}

extension UserResultViewModel {
    private func searchUsers(keyword: String, offset: Int = 0) -> Observable<SearchUserRespone> {
        return services.searchService.searchUsers(keyword: keyword, offset: offset).trackError(errorTracker)
    }
}
