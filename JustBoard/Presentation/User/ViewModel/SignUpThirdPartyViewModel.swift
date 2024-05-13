//
//  SignUpThirdPartyViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpThirdPartyViewModel : UserViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let email : PublishSubject<String>
        let password : PublishSubject<String>
        let nick : BehaviorSubject<String>
    }
    
    struct Output {
        let complete : PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let complete = PublishSubject<Void>()
        let completeJoined = PublishSubject<Void>()
        let loginFailedWithSignUp = PublishSubject<Void>()
        let loginObservable = Observable.combineLatest(input.email, input.password)
            .map {
                return LoginRequest(email: $0, password: $1)
            }
        
        let joinObservable = Observable.combineLatest(input.email, input.password, input.nick)
            .map {
                return JoinRequest(email: $0, password: $1, nick: $2)
            }.share()
        
        loginObservable
            .flatMapLatest { loginQuery in
                return NetworkManager.shared.createLogin(query: loginQuery)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let loginModel):
                    UserDefaultManager.shared.saveAllData(loginResponse: loginModel)
                    complete.onNext(())
                case .failure(let error):
                    
                    if let statusCode = error.responseCode, statusCode == 401 {
                        print(statusCode, "회원가입 진행")
                        loginFailedWithSignUp.onNext(())
                    } else {
                        print(error)
                    }
                    
                    UserDefaultManager.shared.isLogined = false
                }
            }
            .disposed(by: disposeBag)
        
        loginFailedWithSignUp
            .withLatestFrom(joinObservable)
            .flatMapLatest { joinQuery in
                return NetworkManager.shared.createJoin(query: joinQuery)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let joinResponse):
                    completeJoined.onNext(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        completeJoined
            .withLatestFrom(joinObservable)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap{ joinRequest in
                return NetworkManager.shared.createLogin(query: LoginRequest(email: joinRequest.email, password: joinRequest.password))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let loginModel):
                    UserDefaultManager.shared.saveAllData(loginResponse: loginModel)
                    complete.onNext(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            complete: complete
        )
    }
}
