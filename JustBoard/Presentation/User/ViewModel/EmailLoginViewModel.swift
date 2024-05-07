//
//  LoginViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa


final class EmailLoginViewModel : UserViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let email : ControlProperty<String>
        let password : ControlProperty<String>
        let loginButtonTap : ControlEvent<Void>
        let signUpTap : ControlEvent<Void>
    }
    
    struct Output {
        let loginSuccess : Driver<Bool>
        let loginFailed : Driver<Bool>
        let loginButtonUIUpdate : Driver<Bool>
        let signUp : Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let loginSuccess = PublishSubject<Bool>()
        let loginFailed = PublishSubject<Bool>()
        let loginButtonUIUpdate = BehaviorSubject<Bool>(value: false)
        
        let loginObservable = Observable.combineLatest(input.email.asObservable(), input.password.asObservable())
            .map { email, password in
                return LoginRequest(email: email, password: password)
            }
            .share()
        
        //MARK: - 이메일, 패스워드 유효성 검증에 따른 Button 비/활성화 및 alpha 추가
        loginObservable
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, loginRequest in
                let valid = owner.isValidEmail(loginRequest.email) && owner.isValidPassword(loginRequest.password)
                loginButtonUIUpdate.onNext(valid)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 로그인
        input.loginButtonTap
            .withLatestFrom(loginObservable)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest { loginQuery in
                return NetworkManager.shared.createLogin(query: loginQuery)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let loginModel):                    
                    UserDefaultManager.shared.saveAllData(loginResponse: loginModel)
                    loginSuccess.onNext(true)
                case .failure(_):
                    UserDefaultManager.shared.isLogined = false
                    print(UserDefaultManager.shared.isLogined, "✅✅✅✅✅✅")
                    loginFailed.onNext(true)
                }
            }
            .disposed(by: disposeBag)
            
        return Output(loginSuccess: loginSuccess.asDriver(onErrorJustReturn: false),
                      loginFailed: loginFailed.asDriver(onErrorJustReturn: false),
                      loginButtonUIUpdate: loginButtonUIUpdate.asDriver(onErrorJustReturn: false),
                      signUp: input.signUpTap.asDriver()
        )
        
    }
    
    deinit {
        print(#function, "-LoginViewModel 🔆")
    }
    
    
}
