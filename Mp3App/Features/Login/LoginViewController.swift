//
//  LoginViewController.swift
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

class LoginViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
