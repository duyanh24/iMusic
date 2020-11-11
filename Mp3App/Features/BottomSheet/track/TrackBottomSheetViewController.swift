//
//  TrackBottomSheetViewController.swift
//  Mp3App
//
//  Created by Apple on 11/11/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class TrackBottomSheetViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addToFavouriteButton: UIButton!
    @IBOutlet weak var addToPlaylistButton: UIButton!
    
    var viewModel: TrackBottomSheetViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        trackImageView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 5
    }
    
    private func bindViewModel() {
        let input = TrackBottomSheetViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.track
        .subscribe(onNext: { [weak self] track in
            self?.titleLabel.text = track.title
            self?.singerLabel.text = track.user?.username
            guard let url = track.artworkURL else {
                return
            }
            self?.trackImageView.setImage(stringURL: url)
        })
        .disposed(by: disposeBag)
    }
}
