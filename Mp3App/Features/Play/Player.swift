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
    
    let isPlayingTrigger = BehaviorSubject<Bool>(value: false)
    var tracks = [Track]()
    var currentTime = PublishSubject<Int>()
    var duration = PublishSubject<Int>()
    var currentTrack = PublishSubject<Track>()
    var randomMode = BehaviorRelay<Bool>(value: false)
    
    private var player: AVPlayer!
    private var currentTrackIndex = 0
    private var isPlaying = false
    private var played = [Int]()
    
    func startPlayTracks() {
        resetData()
        setupNotificationCenter()
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
        played = []
    }
    
    private func startTracks(track: Track) {
        guard let id = track.id else {
            return
        }
        
        if !played.indices.contains(id) {
            played.append(id)
        }
        
        let trackLink = "https://api.soundcloud.com/tracks/\(id)/stream?client_id=18a54722bf90fb2d9723570ccefa02b3"
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
                    self.player.pause()
                    self.isPlaying = false
                    self.isPlayingTrigger.onNext(self.isPlaying)
                    self.nextTrack(isAutoNext: true)
                }
            }
        }
        currentTrack.onNext(track)
        player.play()
        isPlaying = true
        isPlayingTrigger.onNext(isPlaying)
    }
    
    func prevTrack() {
        if randomMode.value {
            player = nil
            if let track = getRandomTrack() {
                startTracks(track: track)
            }
        } else {
            currentTrackIndex == 0 ? (currentTrackIndex = tracks.count - 1) : (currentTrackIndex -= 1)
            player.pause()
            startTracks(track: tracks[currentTrackIndex])
        }
    }
    
    func nextTrack(isAutoNext: Bool = false) {
        if randomMode.value {
            if let track = getRandomTrack(isAutoNext: isAutoNext) {
                player = nil
                startTracks(track: track)
            }
        } else if currentTrackIndex != tracks.count - 1 {
            currentTrackIndex += 1
            player = nil
            startTracks(track: tracks[currentTrackIndex])
        } else if currentTrackIndex == tracks.count - 1 && !isAutoNext {
            currentTrackIndex = 0
            player = nil
            startTracks(track: tracks[currentTrackIndex])
        }
    }
    
    func playContinue() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
        isPlayingTrigger.onNext(isPlaying)
    }
    
    func setupRandomMode() {
        randomMode.value ? randomMode.accept(false) : randomMode.accept(true)
    }
    
    func seek(seconds: Float) {
        player.play()
        isPlaying = true
        isPlayingTrigger.onNext(isPlaying)
        player.seek(to: CMTime(seconds: Double(seconds), preferredTimescale: 1))
    }
    
    private func getRandomTrack(isAutoNext: Bool = false) -> Track? {
        if !isAutoNext && played.count == tracks.count {
            played = []
        }
        let randomTrack = tracks.filter {
            guard let id = $0.id else {
                return true
            }
            return !played.contains(id)
        }.randomElement()
        guard let track = randomTrack else {
            return nil
        }
        return track
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(playTrackSelected(_:)), name: Notification.Name(Strings.selectedTrackItem), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playTrackSelected(_ notification: Notification) {
        guard let index = notification.userInfo?[Strings.index] as? Int else { return }
        currentTrackIndex = index
        player = nil
        startTracks(track: tracks[index])
    }
}
