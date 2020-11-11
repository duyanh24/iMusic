//
//  LibraryService.swift
//  Mp3App
//
//  Created by Apple on 10/18/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import RxSwift

protocol HasLibraryService {
    var libraryService: LibraryService { get }
}

struct LibraryService {
    func getTracksFromFavourite() -> Observable<Result<[Track], Error>> {
        return FirebaseDatabase.shared.getTracksFromFavourite()
    }
    
    func addTrackToFavourite(track: Track) -> Observable<Result<Void, Error>> {
        return FirebaseDatabase.shared.addTrackToFavourite(track: track)
    }
    
    func checkTrackAlreadyExitsInFavourite(trackId: Int) -> Observable<Result<Bool, Error>> {
        return FirebaseDatabase.shared.checkTrackAlreadyExitsInFavourite(trackId: trackId)
    }
}
