//
//  Player.swift
//  Mp3App
//
//  Created by Apple on 10/26/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa

class Player {
    static let shared = Player()

    private var player: AVPlayer!
    private var currentTrackIndex = 0
    private var isPlaying = false
    
    let isPlayingTrigger = BehaviorSubject<Bool>(value: false)
    var tracks = [Track]()
    var currentTime = PublishSubject<Int>()
    var duration = PublishSubject<Int>()
    var currentTrack = PublishSubject<Track>()
    
    func startPlayTracks() {
        resetData()
        if !tracks.isEmpty {
            guard let track = tracks.first else {
                return
            }
            startTracks(track: track)
        }
    }
    
    private func resetData() {
        player = nil
        currentTrackIndex = 0
        isPlaying = false
    }
    
    private func startTracks(track: Track) {
        guard let id = track.id else {
            return
        }
        let trackLink = "https://api.soundcloud.com/tracks/\(id)/stream?client_id=stJqxq59eT4rgFHFLYiyAL2BDbuL3BAv"
        guard let url = URL.init(string: trackLink) else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            let durationInSeconds = self.player.currentItem?.asset.duration.seconds ?? 0
            self.duration.onNext(Int(durationInSeconds))
            if self.player.currentItem?.status == .readyToPlay {
                let time = CMTimeGetSeconds(self.player.currentTime())
                self.currentTime.onNext(Int(time))
                
                if time >= durationInSeconds - 1 {
                    self.nextTrack()
                }
            }
        }
        
        currentTrack.onNext(track)
        player.play()
        isPlaying = true
        isPlayingTrigger.onNext(isPlaying)
    }
    
    func prevTrack() {
        //player.seek(to: CMTime(seconds: Double(150), preferredTimescale: 1))
        currentTrackIndex == 0 ? (currentTrackIndex = tracks.count - 1) : (currentTrackIndex -= 1)
        player.pause()
        startTracks(track: tracks[currentTrackIndex])
    }
    
    func nextTrack() {
        currentTrackIndex == tracks.count - 1 ? (currentTrackIndex = 0) : (currentTrackIndex += 1)
        player = nil
        startTracks(track: tracks[currentTrackIndex])
    }
    
    func playTrack() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
        isPlayingTrigger.onNext(isPlaying)
    }
}
