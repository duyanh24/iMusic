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

class PlayerView: UIView, NibOwnerLoadable, ViewModelBased {
    @IBOutlet weak var containerView: UIView!
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
    
    private let disposeBag = DisposeBag()
    private var controlPlayerViewY: CGFloat = 0
    private var tracks = PublishSubject<[Track]>()
    var viewModel: PlayerViewModel!
    private var duration = 0
    
    var isScrollEnabled: Bool = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }
    
    var isTableviewOnTop: Bool {
        return trackInformationView.isTableViewOnTop
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
        setupUI()
    }
    
    private func setupUI() {
        setupTrackImageView()
        setupScrollView()
        setupPageControl()
        setupControlPlayerView()
        
    }

    func setTracks(tracks: [Track]) {
        self.tracks.onNext(tracks)
    }
    
    func configureViewModel(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = PlayerViewModel.Input(prevButton: prevButton.rx.tap.asObservable(),
                                          nextButton: nextButton.rx.tap.asObservable().merge(with: miniNextButton.rx.tap.asObservable()),
                                          playButton: playButton.rx.tap.asObservable().merge(with: miniPlayButton.rx.tap.asObservable()),
                                          tracks: tracks)
        let output = viewModel.transform(input: input)
        
        output.playList.subscribe(onNext: { tracks, currentTrack in
                self.trackInformationView.configureViewModel(viewModel: TrackInformationViewModel(tracks: tracks, currentTrack: currentTrack))
        }).disposed(by: disposeBag)
        
        output.startPlayTracks.subscribe().disposed(by: disposeBag)
        output.nextTrack.subscribe().disposed(by: disposeBag)
        output.playTrack.subscribe().disposed(by: disposeBag)
        output.prevTrack.subscribe().disposed(by: disposeBag)
        
        output.currentTrack.subscribe(onNext: { [weak self] track in
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
            self?.setupSliderValue(currentTime: Float(currentTime))
        })
        .disposed(by: disposeBag)
    }
    
    private func setupTrackImageView() {
        trackImageView.layer.cornerRadius = trackImageView.frame.size.height / 2
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.layoutIfNeeded()
        let contentOffset = CGPoint(x: frame.width, y: 0.0)
        scrollView.setContentOffset(contentOffset, animated: false)
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func scrollToPlayerPage() {
        let contentOffset = CGPoint(x: frame.width, y: 0.0)
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
        controlPlayerViewY = frame.height - controlPlayerView.frame.size.height - ScreenSize.getBottomSafeArea()
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

    @IBAction func touchUpSlider(_ sender: Any) {
        print("end")
    }
    
    @IBAction func touchDownSlider(_ sender: Any) {
        print("begin")
    }
}

extension PlayerView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / frame.size.width
        pageControl.currentPage = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        controlPlayerView.frame.origin.y = controlPlayerViewY + (containerBottomView.frame.size.height + ScreenSize.getBottomSafeArea()) * (frame.width - scrollView.contentOffset.x) / frame.width
    }
}

extension Reactive where Base: PlayerView {
    var hide: ControlEvent<Void> {
        return base.hideButton.rx.tap
    }
}
