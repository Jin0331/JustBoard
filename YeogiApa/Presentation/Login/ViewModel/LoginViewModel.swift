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
                return LoginQuery(email: email, password: password)
            }
        
        input.loginButtonTap
            .withLatestFrom(loginObservable)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { loginQuery in
                return NetworkManager.createLogin(query: loginQuery)
            }
            .debug()
            .subscribe(with: self, onNext: { owner, loginModel in
                
                print(loginModel)
                
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }

    
}
