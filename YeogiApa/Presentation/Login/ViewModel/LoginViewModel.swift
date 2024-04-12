//
//  LoginViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa


final class LoginViewModel : ViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let email : ControlProperty<String>
        let password : ControlProperty<String>
        let loginButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let loginSuccess : Driver<Bool>
        let loginFailed : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let loginSuccess = PublishSubject<Bool>()
        let loginFailed = PublishSubject<Bool>()
        
        let loginObservable = Observable.combineLatest(input.email.asObservable(), input.password.asObservable())
            .map { email, password in
                return LoginRequest(email: email, password: password)
            }
        
        input.loginButtonTap
            .withLatestFrom(loginObservable)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest { loginQuery in
                return NetworkManager.shared.createLogin(query: loginQuery)
            }
            .debug()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let loginModel):
                    UserDefaultManager.shared.accessToken = loginModel.accessToken
                    UserDefaultManager.shared.refreshToken = loginModel.refreshToken
                    
                    loginSuccess.onNext(true)
                case .failure(_):
                    loginFailed.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(loginSuccess: loginSuccess.asDriver(onErrorJustReturn: false),
                      loginFailed: loginFailed.asDriver(onErrorJustReturn: false))
    }

    
}
