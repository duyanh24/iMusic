//
//  CreatePlaylistViewController.swift
//  Mp3App
//
//  Created by AnhLD on 10/15/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class CreatePlaylistViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet var playlistTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var errorLabel: UILabel!
    
    var viewModel: CreatePlaylistViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareUI() {
        super.prepareUI()
        createButton.layer.cornerRadius = createButton.frame.size.height / 2
    }
    
    private func bindViewModel() {
        let input = CreatePlaylistViewModel.Input(createPlaylist: createButton.rx.tap.asObservable(), newPlaylist: playlistTextField.rx.text.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.isCreatePlaylistEnabled.bind(to: createButton.rx.isEnabled).disposed(by: disposeBag)
        
        output.isCreatePlaylistEnabled.subscribe(onNext: { [weak self] isCreatePlaylistEnabled in
            if isCreatePlaylistEnabled {
                self?.createButton.backgroundColor = .purple
            } else {
                self?.createButton.backgroundColor = .gray
            }
        }).disposed(by: disposeBag)
        
        output.activityIndicator.bind(to: ProgressHUD.rx.isAnimating).disposed(by: disposeBag)
        
        output.createPlaylistResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.errorLabel.text = error.localizedDescription
            case .success:
                NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
                SceneCoordinator.shared.pop(animated: true, toRoot: true)
            }
        }).disposed(by: disposeBag)
    }
}
