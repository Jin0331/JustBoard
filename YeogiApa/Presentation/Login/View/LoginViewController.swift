//
//  LoginViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

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
        output.loginSuccess
            .drive(with: self) { owner, value in
                print("로그인 성공", value)
            }
            .disposed(by: disposeBag)
        
        output.loginFailed
            .drive(with: self) { owner, value in
                print("로그인 실패", value)
                owner.showAlert(title: "로그인 실패", text: "이메일 또는 비밀번호가 틀렸어요 🥲", addButtonText: "확인")
            }
            .disposed(by: disposeBag)
        
    }
}
