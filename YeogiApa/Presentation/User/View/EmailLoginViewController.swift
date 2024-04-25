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

final class EmailLoginViewController: RxBaseViewController {
    
    private let mainView = EmailLoginView()
    private let viewModel = EmailLoginViewModel()
    weak var parentCoordinator : EmailLoginCoordinator?
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func bind() {
        let input = EmailLoginViewModel.Input(email: mainView.userIdTextfield.rx.text.orEmpty,
                                         password: mainView.userPasswordTextfield.rx.text.orEmpty,
                                         loginButtonTap: mainView.userLoginButton.rx.tap,
                                         signUpTap: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginButtonUIUpdate
            .drive(with: self) { owner, value in
                owner.mainView.userLoginButton.isEnabled = value
                owner.mainView.userLoginButton.alpha = value ? 1.0 : 0.5
            }
            .disposed(by: disposeBag)
        
        output.loginSuccess
            .drive(with: self) { owner, value in
                print("로그인 성공", value)
                
                //TODO: - 화면전환 로직 추가 필요
                owner.parentCoordinator?.didLogined()
            }
            .disposed(by: disposeBag)
        
        output.loginFailed
            .drive(with: self) { owner, value in
                print("로그인 실패", value)
                owner.showAlert(title: "로그인 실패", text: "이메일 또는 비밀번호가 틀렸어요 🥲", addButtonText: "확인")
            }
            .disposed(by: disposeBag)
        
        output.signUp
            .drive(with: self) { owner, _ in
                owner.parentCoordinator?.signUp()
            }
            .disposed(by: disposeBag)
    }
}
