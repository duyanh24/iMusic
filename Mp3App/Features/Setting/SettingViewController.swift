//
//  SettingViewController.swift
//  Mp3App
//
//  Created by AnhLD on 9/29/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class SettingViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var serviceTermsButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutContainer: UIView!
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: SettingViewModel!
    private let disposeBag = DisposeBag()
    private let logoutTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepareUI() {
        super.prepareUI()
        avatarView.layer.cornerRadius = 20
    }
    
    private func bindViewModel() {
        let input = SettingViewModel.Input(logout: logoutTrigger)
        
        let output = viewModel.transform(input: input)
        
        logoutButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.showConfirmMessage(title: Strings.logout, message: Strings.confirmLogout, confirmTitle: Strings.confirm, cancelTitle: Strings.cancel) { [weak self] selectedCase in
                if selectedCase == .confirm {
                    self?.logoutTrigger.onNext(())
                }
            }
        }).disposed(by: disposeBag)
        
        output.logoutSuccess.subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.tabbar)
        })
        .disposed(by: disposeBag)
        
        output.email.subscribe(onNext: { [weak self] email in
            if email.isEmpty {
                self?.emailLabel.text = Strings.notLoggedIn
            } else {
                self?.emailLabel.text = email
                self?.avatarLabel.text = String(email.prefix(1)).uppercased()
            }
        })
        .disposed(by: disposeBag)
        
        helpButton.rx.tap.subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.webView(url: Strings.helpURL))
        }).disposed(by: disposeBag)
        
        serviceTermsButton.rx.tap.subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.webView(url: Strings.serviceTermsURL))
        }).disposed(by: disposeBag)
        
        privacyPolicyButton.rx.tap.subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.webView(url: Strings.privacyPolicyURL))
        }).disposed(by: disposeBag)
        
        output.checkLogin.subscribe(onNext: { [weak self] isLoggedIn in
            self?.loginContainer.isHidden = isLoggedIn
            self?.logoutContainer.isHidden = !isLoggedIn
        })
        .disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { _ in
            SceneCoordinator.shared.transition(to: Scene.login)
        })
        .disposed(by: disposeBag)
    }
}
