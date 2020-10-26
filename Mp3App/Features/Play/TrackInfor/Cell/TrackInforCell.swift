//
//  TrackInforCell.swift
//  Mp3App
//
//  Created by AnhLD on 10/22/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class TrackInforCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: TrackInforCellViewModel!
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
        containerView.layer.cornerRadius = 5
    }
    
    func configureCell(viewModel: TrackInforCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func bindViewModel() {
        let input = TrackInforCellViewModel.Input()
        let output = viewModel.transform(input: input)
                
        output.track.subscribe(onNext: { [weak self] track in
            self?.titleLabel.text = track.title
            self?.albumLabel.text = track.title
            self?.singerLabel.text = track.description
            self?.genreLabel.text = track.genre
        })
        .disposed(by: disposeBag)
    }
}
