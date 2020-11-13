//
//  RootTabbarController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import MaterialComponents.MaterialBottomSheet

class RootTabbarController: UITabBarController, StoryboardBased {
    private var tabbarY: CGFloat!
    private let miniPlayerHeight: CGFloat = 52
    var playerView: PlayerViewController!
    private let containerView = UIView()
    
    private let disposeBag = DisposeBag()
    private var isTabbarShow = true
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return true
    }
    
    override func loadView() {
        super.loadView()
        createPlayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        setupNotificationCenter()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPlayerView()
    }
    
    private func createPlayerView() {
        let playerViewModel = PlayerViewModel()
        let services = PlayerServices(playlistService: PlaylistService(), trackService: TrackService(), libraryService: LibraryService())
        playerView = PlayerViewController.instantiate(withViewModel: playerViewModel, andServices: services)
    }
    
    private func setupPlayerView() {
        containerView.frame = CGRect(x: 0,
                                     y: UIScreen.main.bounds.height - getTabbarHeight(),
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height + miniPlayerHeight)
        view.addSubview(containerView)
        addChild(playerView)
        playerView.view.frame = containerView.bounds
        containerView.addSubview(playerView.view)
        playerView.didMove(toParent: self)
        
        view.bringSubviewToFront(tabBar)
        tabbarY = tabBar.frame.origin.y
        
        playerView.rx.hide.subscribe(onNext: { [weak self] _ in
            guard let tabbarY = self?.tabbarY, let miniPlayerHeight = self?.miniPlayerHeight else {
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self?.containerView.frame.origin.y = tabbarY - miniPlayerHeight
                self?.selectedViewController?.view.alpha = 1
                self?.tabBar.frame.origin.y = tabbarY
                self?.playerView.scrollToPlayerPage()
                self?.isTabbarShow = true
            })
        }).disposed(by: disposeBag)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPlayer(_:)), name: Notification.Name(Strings.playerNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTrackOption(_:)), name: Notification.Name(Strings.ShowTrackOption), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPlaylistOption(_:)), name: Notification.Name(Strings.ShowPlaylistOption), object: nil)
    }
    
    @objc func showPlayer(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.frame.origin.y = 0 - self.miniPlayerHeight
            self.selectedViewController?.view.alpha = 0
            self.tabBar.frame.origin.y = self.tabbarY + self.tabBar.frame.height
            self.isTabbarShow = false
        })
        guard let tracks = notification.userInfo?[Strings.tracks] as? [Track] else { return }
        playerView.setTracks(tracks: tracks)
    }
    
    @objc func showTrackOption(_ notification: Notification) {
        guard let track = notification.userInfo?[Strings.tracks] as? Track else { return }
        let trackBottomSheetViewModel = TrackBottomSheetViewModel(track: track)
        let services = MypageServices(playlistService: PlaylistService(), trackService: TrackService(), libraryService: LibraryService())
        let trackBottomSheetViewController = TrackBottomSheetViewController.instantiate(withViewModel: trackBottomSheetViewModel, andServices: services)
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: trackBottomSheetViewController)
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc func showPlaylistOption(_ notification: Notification) {
        guard let track = notification.userInfo?[Strings.tracks] as? Track else { return }
        let playlistBottomSheetViewModel = PlaylistBottomSheetViewModel(track: track)
        let services = MypageServices(playlistService: PlaylistService(), trackService: TrackService(), libraryService: LibraryService())
        let playlistBottomSheetViewController = PlaylistBottomSheetViewController.instantiate(withViewModel: playlistBottomSheetViewModel, andServices: services)
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: playlistBottomSheetViewController)
        present(bottomSheet, animated: true, completion: nil)
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        containerView.addGestureRecognizer(panGesture)
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        panGesture.cancelsTouchesInView = false
    }
    
    @objc func panGestureRecognizerAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let contentHeight = UIScreen.main.bounds.height - tabBar.frame.height - miniPlayerHeight
        if containerView.frame.origin.y > 0 - miniPlayerHeight {
            switch gesture.state {
            case .began:
                playerView.isScrollEnabled = false
            case .changed:
                let containerViewY = containerView.frame.origin.y
                if containerViewY <= contentHeight {
                    if containerViewY + translation.y < 0 - miniPlayerHeight {
                        containerView.frame.origin.y = view.bounds.origin.y - miniPlayerHeight
                        tabBar.frame.origin.y = tabbarY + tabBar.frame.height
                    } else if containerViewY + translation.y > contentHeight {
                        containerView.frame.origin.y = contentHeight
                        tabBar.frame.origin.y = tabbarY
                    } else {
                        containerView.frame.origin.y += translation.y
                        tabBar.frame.origin.y -= translation.y * (tabBar.frame.height/contentHeight)
                    }
                    selectedViewController?.view.alpha = containerViewY / contentHeight
                    gesture.setTranslation(.zero, in: view)
                }
            case .ended:
                let velocity = gesture.velocity(in: view)
                if velocity.y > 0 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.containerView.frame.origin.y = self.tabbarY - self.miniPlayerHeight
                        self.selectedViewController?.view.alpha = 1
                        self.tabBar.frame.origin.y = self.tabbarY
                        self.isTabbarShow = true
                    })
                    playerView.scrollToPlayerPage()
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.containerView.frame.origin.y = 0 - self.miniPlayerHeight
                        self.selectedViewController?.view.alpha = 0
                        self.tabBar.frame.origin.y = self.tabbarY + self.tabBar.frame.height
                        self.isTabbarShow = false
                    })
                }
                playerView.isScrollEnabled = true
            default:
                break
            }
        }
    }
}

extension RootTabbarController {
    @objc private func willEnterForeground() {
        isTabbarShow ? (tabBar.frame.origin.y = tabbarY) : (tabBar.frame.origin.y = tabbarY + tabBar.frame.height)
    }
}

extension RootTabbarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = gesture.velocity(in: containerView)
        return abs(velocity.x) < abs(velocity.y)
    }
}
