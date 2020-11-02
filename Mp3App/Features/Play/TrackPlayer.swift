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

class TrackPlayer {
    static let shared = TrackPlayer()
    
    var tracks = [Track]()
    let isPlayingTrigger = BehaviorSubject<Bool>(value: false)
    let currentTime = PublishSubject<Int>()
    let duration = PublishSubject<Int>()
    let currentTrack = BehaviorRelay<Track?>(value: nil)
    let randomMode = BehaviorRelay<Bool>(value: false)
    let repeatMode = BehaviorRelay<Bool>(value: false)
    
    private var player: AVPlayer?
    private var currentTrackIndex = 0
    private var isPlaying = false
    private var tracksPlayedId = [Int]()
    
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
        tracksPlayedId = []
    }
    
    private func startTracks(track: Track) {
        guard let id = track.id else {
            return
        }
        if !tracksPlayedId.contains(id) {
            tracksPlayedId.append(id)
        }
        let trackLink = String(format: APIURL.APIStream, id)
        guard let url = URL.init(string: trackLink) else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        guard let player = player else {
            return
        }
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            guard let player = self.player else {
                return
            }
            let durationInSeconds = player.currentItem?.asset.duration.seconds ?? 0
            self.duration.onNext(Int(durationInSeconds))
            if self.player?.currentItem?.status == .readyToPlay {
                let time = CMTimeGetSeconds(player.currentTime())
                self.currentTime.onNext(Int(time))
                
                if time >= durationInSeconds - 1 {
                    player.pause()
                    self.isPlaying = false
                    self.isPlayingTrigger.onNext(self.isPlaying)
                    self.nextTrack(isAutoNext: true)
                }
            }
        }
        currentTrack.accept(track)
        player.play()
        isPlaying = true
        isPlayingTrigger.onNext(isPlaying)
    }
    
    func prevTrack() {
        if player == nil {
            return
        } else {
            player = nil
        }
        if randomMode.value {
            if let track = getRandomTrack() {
                startTracks(track: track)
            }
        } else {
            currentTrackIndex == 0 ? (currentTrackIndex = tracks.count - 1) : (currentTrackIndex -= 1)
            startTracks(track: tracks[currentTrackIndex])
        }
    }
    
    func nextTrack(isAutoNext: Bool = false) {
        if player == nil {
            return
        }
        if player != nil && !isAutoNext {
            player = nil
        }
        if repeatMode.value, var currentTrack = currentTrack.value {
            if !currentTrack.isRepeated {
                currentTrack.isRepeated = true
                startTracks(track: currentTrack)
                return
            }
        }
        if randomMode.value, let track = getRandomTrack(isAutoNext: isAutoNext) {
            startTracks(track: track)
        } else if currentTrackIndex != tracks.count - 1 {
            currentTrackIndex += 1
            startTracks(track: tracks[currentTrackIndex])
        } else if currentTrackIndex == tracks.count - 1 && !isAutoNext {
            currentTrackIndex = 0
            startTracks(track: tracks[currentTrackIndex])
        }
    }
    
    func playContinue() {
        guard let player = player else {
            return
        }
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
    
    func setupRepeatMode() {
        repeatMode.value ? repeatMode.accept(false) : repeatMode.accept(true)
    }
    
    func seek(seconds: Float) {
        guard let player = player else {
            return
        }
        player.play()
        isPlaying = true
        isPlayingTrigger.onNext(isPlaying)
        player.seek(to: CMTime(seconds: Double(seconds), preferredTimescale: 1))
    }
    
    private func getRandomTrack(isAutoNext: Bool = false) -> Track? {
        if !isAutoNext && tracksPlayedId.count == tracks.count {
            tracksPlayedId = []
        }
        let randomTrack = tracks.filter {
            guard let id = $0.id else {
                return true
            }
            return !tracksPlayedId.contains(id)
        }.randomElement()
        guard let track = randomTrack else {
            return nil
        }
        return track
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(playTrackSelected(_:)), name: Notification.Name(Strings.selectedTrackItem), object: nil)
    }
    
    @objc func playTrackSelected(_ notification: Notification) {
        guard let index = notification.userInfo?[Strings.index] as? Int else { return }
        currentTrackIndex = index
        player = nil
        startTracks(track: tracks[index])
    }
}
