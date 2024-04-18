//
//  SignInUpViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInUpViewController : RxBaseViewController{
    
    private let mainView = SignInUpView()
    var delegate : UserCoordinator?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func bind() {

        mainView.kakaoLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                //TODO: - 소셜로그인 적용시 화면전환
                owner.delegate?.kakaoLogin()
            }
            .disposed(by: disposeBag)
        
        mainView.appleLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                //TODO: - 소셜로그인 적용시 화면전환
                owner.delegate?.appleLogin()
            }
            .disposed(by: disposeBag)
        
        mainView.emailLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                print("hi")
                owner.delegate?.emailLogin()
            }
            .disposed(by: disposeBag)
    }
    
}
