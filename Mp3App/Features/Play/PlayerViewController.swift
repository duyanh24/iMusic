//
//  PlayerView.swift
//  Mp3App
//
//  Created by AnhLD on 10/19/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class PlayerViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topContentStackView: UIStackView!
    @IBOutlet weak var audioPlayerView: AudioPlayerView!
    @IBOutlet weak var trackInformationView: TrackInformationView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var controlPlayerView: UIView!
    @IBOutlet weak var containerBottomView: UIView!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var titeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleMiniPlayerLabel: UILabel!
    @IBOutlet weak var descriptionMiniPlayerLabel: UILabel!
    @IBOutlet weak var miniPlayerImageView: UIImageView!
    @IBOutlet weak var miniPlayerSlider: UISlider!
    @IBOutlet weak var miniPlayButton: UIButton!
    @IBOutlet weak var miniNextButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var randomModeImageView: UIImageView!
    @IBOutlet weak var repeatModeButton: UIButton!
    @IBOutlet weak var repeatModeImageView: UIImageView!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var addTrackToFavouriteButton: UIButton!
    @IBOutlet weak var miniAddTrackToFavouriteButton: UIButton!
    
    private var isViewDidAppear = false
    
    var viewModel: PlayerViewModel!
    private let disposeBag = DisposeBag()
    private var controlPlayerViewY: CGFloat = 0
    private var tracks = PublishSubject<[Track]>()
    private var duration = 0
    private let seekValueSlider = PublishSubject<Float>()
    private var isChangingSlider = false
    private let isTrackAlreadyExistsInFavorites = BehaviorRelay<Bool>(value: false)
    
    var isScrollEnabled: Bool = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }
    
    var isTableviewOnTop: Bool {
        return trackInformationView.isTableViewOnTop
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isViewDidAppear {
            setupScrollView()
            setupControlPlayerView()
            audioPlayerView.setCornerRadius()
            isViewDidAppear = true
        }
    }
    
    override func prepareUI() {
        super.prepareUI()
        setupTrackImageView()
        setupPageControl()
    }

    func setTracks(tracks: [Track]) {
        self.tracks.onNext(tracks)
    }
    
    private func bindViewModel() {
        let input = PlayerViewModel.Input(prevButton: prevButton.rx.tap.asObservable(),
                                          nextButton: nextButton.rx.tap.asObservable().merge(with: miniNextButton.rx.tap.asObservable()),
                                          playButton: playButton.rx.tap.asObservable().merge(with: miniPlayButton.rx.tap.asObservable()),
                                          randomModeButton: randomButton.rx.tap.asObservable(),
                                          repeatModeButton: repeatModeButton.rx.tap.asObservable(),
                                          tracks: tracks,
                                          seekValueSlider: seekValueSlider,
                                          addTrackToFavouriteButton: addTrackToFavouriteButton.rx.tap.asObservable().merge(with: miniAddTrackToFavouriteButton.rx.tap.asObservable()))
        let output = viewModel.transform(input: input)
        
        output.playList.subscribe(onNext: { tracks, currentTrack in
                self.trackInformationView.configureViewModel(viewModel: TrackInformationViewModel(tracks: tracks, currentTrack: currentTrack))
        }).disposed(by: disposeBag)
        
        output.startPlayTracks.subscribe().disposed(by: disposeBag)
        output.nextTrack.subscribe().disposed(by: disposeBag)
        output.playTrack.subscribe().disposed(by: disposeBag)
        output.prevTrack.subscribe().disposed(by: disposeBag)
        output.seekTrack.subscribe().disposed(by: disposeBag)
        output.randomMode.subscribe().disposed(by: disposeBag)
        output.repeatMode.subscribe().disposed(by: disposeBag)
        
        output.currentTrack.subscribe(onNext: { [weak self] track in
            guard let track = track else {
                return
            }
            self?.setupContent(track: track)
        })
        .disposed(by: disposeBag)
        
        output.isPlaying.subscribe(onNext: { [weak self] isPlaying in
            self?.setupRotation(isPlaying: isPlaying)
        })
        .disposed(by: disposeBag)
        
        output.duration.subscribe(onNext: { [weak self] duration in
            self?.duration = duration
            self?.slider.maximumValue = Float(duration)
            self?.miniPlayerSlider.maximumValue = Float(duration)
        })
        .disposed(by: disposeBag)
        
        output.currentTime.subscribe(onNext: { [weak self] currentTime in
            guard let isChangingSlider = self?.isChangingSlider else {
                return
            }
            if !isChangingSlider {
                self?.setupSliderValue(currentTime: Float(currentTime))
            }
        })
        .disposed(by: disposeBag)
        
        output.isRandomModeSelected.subscribe(onNext: { [weak self] isRandomModeSelected in
            isRandomModeSelected ? (self?.randomModeImageView.image = Asset.playerButtonShuffleActiveNormal.image) : (self?.randomModeImageView.image = Asset.playerButtonShuffleNormalNormal.image)
        })
        .disposed(by: disposeBag)
        
        output.isRepeatModeSelected.subscribe(onNext: { [weak self] isRepeatModeSelected in
            isRepeatModeSelected ? (self?.repeatModeImageView.image = Asset.playerButtonRepeatoneActiveNormal.image) : (self?.repeatModeImageView.image = Asset.playerButtonRepeatNormalNormal.image)
        })
        .disposed(by: disposeBag)
        
        output.isTrackAlreadyExistsInFavorites.subscribe(onNext: { [weak self] value in
            self?.isTrackAlreadyExistsInFavorites.accept(value)
        }).disposed(by: disposeBag)
        
        output.addTrackToFavouriteResult.subscribe(onNext: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.isTrackAlreadyExistsInFavorites.accept(!self.isTrackAlreadyExistsInFavorites.value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        .disposed(by: disposeBag)
        
        isTrackAlreadyExistsInFavorites.skip(1).subscribe(onNext: { isTrackAlreadyExistsInFavorites in
            if isTrackAlreadyExistsInFavorites {
                self.favouriteImageView.image = Asset.feedLikeSelectedIcoNormal.image
                self.miniAddTrackToFavouriteButton.setImage(Asset.icFeedLike48Normal.image, for: .normal)
            } else {
                self.favouriteImageView.image = Asset.icHeartWhite2020Normal.image
                self.miniAddTrackToFavouriteButton.setImage(Asset.icHeartBlack2020Normal.image, for: .normal)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func setupTrackImageView() {
        trackImageView.layer.cornerRadius = trackImageView.frame.size.height / 2
    }
    
    private func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.layoutIfNeeded()
        let contentOffset = CGPoint(x: view.bounds.width, y: 0.0)
        scrollView.setContentOffset(contentOffset, animated: false)
        
    }
    
    func scrollToPlayerPage() {
        let contentOffset = CGPoint(x: view.bounds.width, y: 0.0)
        scrollView.setContentOffset(contentOffset, animated: false)
        pageControl.currentPage = 1
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = 2
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 1
    }
    
    private func setupThumbSlider(currentValue: Int, maxValue: Int) {
        slider.setProgressTime(time: Converter.stringFromTimeInterval(interval: currentValue) + " / " + Converter.stringFromTimeInterval(interval: maxValue))
    }
    
    private func setupControlPlayerView() {
        controlPlayerView.layoutIfNeeded()
        controlPlayerViewY = view.bounds.height - controlPlayerView.frame.size.height - ScreenSize.getBottomSafeArea()
    }
    
    private func setupSliderValue(currentTime: Float) {
        slider.value = currentTime
        miniPlayerSlider.value = currentTime
        setupThumbSlider(currentValue: Int(currentTime), maxValue: duration)
    }
    
    private func setupContent(track: Track) {
        titeLabel.text = track.title
        titleMiniPlayerLabel.text = track.title
        descriptionLabel.text = track.description
        descriptionMiniPlayerLabel.text = track.description
        guard let url = track.artworkURL else {
            return
        }
        audioPlayerView.setupDiskImage(url: url)
        miniPlayerImageView.setImage(stringURL: url)
    }
    
    private func setupRotation(isPlaying: Bool) {
        if isPlaying {
            playImageView.image = Asset.pause64Normal.image
            miniPlayButton.setImage(Asset.icPauseNormal.image, for: .normal)
            audioPlayerView.rotateImageView()
            miniPlayerImageView.rotate()
        } else {
            playImageView.image = Asset.play64Normal.image
            miniPlayButton.setImage(Asset.icPlayNormalBlack.image, for: .normal)
            miniPlayButton.tintColor = .black
            audioPlayerView.stopRotateImageView()
            miniPlayerImageView.stopRotating()
        }
    }
    
    @IBAction func valueChangedSlider(_ sender: Any) {
        setupSliderValue(currentTime: slider.value)
    }
    @IBAction func touchDownSlider(_ sender: Any) {
        isChangingSlider = true
    }
    @IBAction func touchUpSlider(_ sender: Any) {
        seekValueSlider.onNext(slider.value)
        isChangingSlider = false
    }
}

extension PlayerViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / view.bounds.size.width
        pageControl.currentPage = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        controlPlayerView.frame.origin.y = controlPlayerViewY + (containerBottomView.frame.size.height + ScreenSize.getBottomSafeArea()) * (view.bounds.width - scrollView.contentOffset.x) / view.bounds.width
    }
}

extension Reactive where Base: PlayerViewController {
    var hide: ControlEvent<Void> {
        return base.hideButton.rx.tap
    }
}
