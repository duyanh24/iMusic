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
    private static var player: AVPlayer!
    private static var currentTrack = 0
    private static var isPlaying = false
    static var tracks: [Track] = []
    static var currentTime = PublishSubject<Int>()
    static var duration = PublishSubject<Int>()
    
    var isChanging = false
    var play = false
    var timeObserverToken: Any?
    
    static func startPlayTracks() {
        if !tracks.isEmpty {
            guard let track = tracks.first else {
                return
            }
            startTracks(track: track)
        }
    }
    
    private static func startTracks(track: Track) {
        guard let id = track.id else {
            return
        }
        let trackLink = "https://api.soundcloud.com/tracks/\(id)/stream?client_id=c4c979fd6f241b5b30431d722af212e8"
        guard let url = URL.init(string: trackLink) else {
            return
        }
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            let durationInSeconds = player.currentItem?.asset.duration.seconds ?? 0
            duration.onNext(Int(durationInSeconds))
            if self.player.currentItem?.status == .readyToPlay {
                let time = CMTimeGetSeconds(self.player.currentTime())
                currentTime.onNext(Int(time))
            }
        }
        player.play()
        isPlaying = true
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if keyPath == #keyPath(AVPlayerItem.status), let statusNumber = change?[.newKey] as? NSNumber {
//
//            switch statusNumber.intValue {
//            case AVPlayerItem.Status.readyToPlay.rawValue:
//                let durationInSeconds = Player.player.currentItem?.asset.duration.seconds ?? 0
//                print("Ready to play. Duration (in seconds): \(durationInSeconds)")
//                slider.maximumValue = Float(durationInSeconds)
//                timeEndLabel.text = String(durationInSeconds)
//                timeStartLabel.text = String(player.currentTime().seconds)
//                slider.value = Float(player.currentTime().seconds)
//            default: break
//            }
//        }
//    }
    
    
    static func nextTrack() {
        currentTrack == tracks.count - 1 ? (currentTrack = 0) : (currentTrack += 1)
        player.pause()
        startTracks(track: tracks[currentTrack])
    }
    
    static func playTrack() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

//    @IBAction func start(_ sender: Any) {
//        //player.pause()
//        playSong(url: listSong[currentSong])
//        play = true
//    }
//
//    @IBAction func prev(_ sender: Any) {
//        play = true
//        currentSong == 0 ? (currentSong = listSong.count - 1) : (currentSong -= 1)
//        player.pause()
//        playSong(url: listSong[currentSong])
//    }
//
//    @IBAction func play(_ sender: Any) {
//        if play {
//            player.pause()
//            play = false
//        } else {
//            player.play()
//            play = true
//        }
//    }
//
//    @IBAction func next(_ sender: Any) {
//        play = true
//        currentSong == listSong.count - 1 ? (currentSong = 0) : (currentSong += 1)
//        player.pause()
//        playSong(url: listSong[currentSong])
//    }
//
//    func playSong(url: String) {
//        let url  = URL.init(string: url)
//        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
//        player = AVPlayer(playerItem: playerItem)
////        let playerLayer = AVPlayerLayer(player: player!)
////        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
////        self.view.layer.addSublayer(playerLayer)
//
//        let timeScale = CMTimeScale(NSEC_PER_SEC)
//        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
//
//        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
//            self?.timeStartLabel.text = String(time.seconds)
//            self?.slider.value = Float(time.seconds)
//        }
//
//        player.currentItem?.addObserver(self as! NSObject, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
//        player.play()
//
//    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if keyPath == #keyPath(AVPlayerItem.status), let statusNumber = change?[.newKey] as? NSNumber {
//
//            switch statusNumber.intValue {
//            case AVPlayerItem.Status.readyToPlay.rawValue:
//                let durationInSeconds = player.currentItem?.asset.duration.seconds ?? 0
//                print("Ready to play. Duration (in seconds): \(durationInSeconds)")
//                slider.maximumValue = Float(durationInSeconds)
//                timeEndLabel.text = String(durationInSeconds)
//                timeStartLabel.text = String(player.currentTime().seconds)
//                slider.value = Float(player.currentTime().seconds)
//            default: break
//            }
//        }
//    }
//    @IBAction func change(_ sender: Any) {
//        player.pause()
//        player.seek(to: CMTime(seconds: Double(slider.value), preferredTimescale: 1))
//        player.play()
//    }
}
