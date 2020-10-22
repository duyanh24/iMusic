//
//  TrackCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class TrackCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    var viewModel: TrackCellViewModel!
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        selectionStyle = .none
        trackImageView.layer.cornerRadius = 5
    }
    
    func configureCell(viewModel: TrackCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = TrackCellViewModel.Input()
        let output = viewModel.transform(input: input)
                
        output.track.subscribe(onNext: { [weak self] track in
            self?.titleLabel.text = track.title
            self?.singerLabel.text = track.description
            guard let url = track.artworkURL else {
                return
            }
            self?.trackImageView?.setImage(stringURL: url)
        })
        .disposed(by: disposeBag)
    }
}