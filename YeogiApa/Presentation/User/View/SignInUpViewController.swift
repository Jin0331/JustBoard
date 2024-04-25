//
//  SignInUpViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationCenter

final class SignInUpViewController : RxBaseViewController{
    
    private let mainView = SignInUpView()
    private var isReset : Bool?
    var parentCoordinator : UserCoordinator?
    
    init(isReset: Bool? = nil) {
        self.isReset = isReset
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, "SignInUpViewController✅")

        if let isReset {
            showAlert(title: "로그인 세션 만료", text: "다시 로그인 해주세요 🥲", addButtonText: "확인")
        }
    }
    
    override func bind() {

        mainView.kakaoLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                //TODO: - 소셜로그인 적용시 화면전환
                owner.parentCoordinator?.kakaoLogin()
            }
            .disposed(by: disposeBag)
        
        mainView.appleLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                //TODO: - 소셜로그인 적용시 화면전환
                owner.parentCoordinator?.appleLogin()
            }
            .disposed(by: disposeBag)
        
        mainView.emailLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                print("hi")
                owner.parentCoordinator?.emailLogin()
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print(#function, "SignInUpViewController✅")
    }
    
}
