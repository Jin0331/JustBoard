//
//  SignInUpViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignInUpViewControllerDelegate {
    func kakaoLogin()
    func appleLogin()
    func emailLogin()
}

final class SignInUpViewController : RxBaseViewController{
    
    private let mainView = SignInUpView()
    var loginDelegate : SignInUpViewControllerDelegate?
    
    
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
                owner.loginDelegate?.kakaoLogin()
            }
            .disposed(by: disposeBag)
        
        mainView.appleLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                //TODO: - 소셜로그인 적용시 화면전환
                owner.loginDelegate?.appleLogin()
            }
            .disposed(by: disposeBag)
        
        mainView.emailLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                //TODO: - 소셜로그인 적용시 화면전환
                
                owner.loginDelegate?.emailLogin()
            }
            .disposed(by: disposeBag)
    }
    
}
