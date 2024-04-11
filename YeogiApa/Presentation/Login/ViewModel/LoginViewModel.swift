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
        
    }
    
    func transform(input: Input) -> Output {
        
        let loginObservable = Observable.combineLatest(input.email.asObservable(), input.password.asObservable())
            .map { email, password in
                return LoginRequest(email: email, password: password)
            }
        
        input.loginButtonTap
            .withLatestFrom(loginObservable)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { loginQuery in
                return NetworkManager.shared.createLogin(query: loginQuery)
            }
            .debug()
            .subscribe(with: self, onNext: { owner, loginModel in
                
                //TODO: - 필요하다면, KeyChain으로 변경?
                UserDefaultManager.shared.accessToken = loginModel.accessToken
                UserDefaultManager.shared.refreshToken = loginModel.refreshToken
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }

    
}
