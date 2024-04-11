//
//  LoginViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: RxBaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func bind() {
        let input = LoginViewModel.Input(email: mainView.userIdTextfield.rx.text.orEmpty,
                                         password: mainView.userPasswordTextfield.rx.text.orEmpty,
                                         loginButtonTap: mainView.userLoginButton.rx.tap)
        
        let output = viewModel.transform(input: input)
    }
}
