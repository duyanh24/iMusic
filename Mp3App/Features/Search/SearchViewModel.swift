//
//  SearchViewModel.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ServicesViewModel {
    var services: SearchServices!
    
    func transform(input: Input) -> Output {
        let saveHistory = input.keyword.do(onNext: { [weak self] keyword in
            self?.services.searchService.saveSearchHistory(keyword: keyword)
        }).mapToVoid()
        
        let dataSource = input.showHistory.flatMapLatest { text -> Observable<[String]> in
            guard let text = text else {
                return .empty()
            }
            if text.isEmpty {
                return Observable.just(SearchHistoryDefault.shared.retrieveData(key: .searchHistory))
            } else {
                return .empty()
            }
        }.map { historyList -> [HistorySectionModel] in
            return [HistorySectionModel(model: "", items: historyList)]
        }
        
        let clearHistory = input.clearHistory.do(onNext: { _ in
            SearchHistoryDefault.shared.clearData()
        }).mapToVoid()
        
        return Output(saveHistory: saveHistory, historyDataSource: dataSource, clearHistory: clearHistory)
    }
}

extension SearchViewModel {
    struct Input {
        var keyword: Observable<String>
        var showHistory: Observable<String?>
        var clearHistory: Observable<Void>
    }
    
    struct Output {
        var saveHistory: Observable<Void>
        var historyDataSource: Observable<[HistorySectionModel]>
        var clearHistory: Observable<Void>
    }
}
