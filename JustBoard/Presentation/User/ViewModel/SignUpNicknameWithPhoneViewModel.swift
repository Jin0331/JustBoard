//
//  SignUpNicknameWithPhoneViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpNicknameWithPhoneViewModel : UserViewModelType {
    
    var email : String
    var password : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(email : String, password : String) {
        self.email = email
        self.password = password
    }
    
    struct Input {
        let nickname : ControlProperty<String>
        let completeButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let completeButtonUIUpdate : Driver<Bool>
        let signUpComplete : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validEmail = BehaviorSubject<String>(value: email)
        let validPassword = BehaviorSubject<String>(value: password)
        let validNickname = PublishSubject<String>()
        let completeButtonUIUpdate = BehaviorSubject<Bool>(value: false)
        let completeJoined = PublishSubject<Void>()
        let completeUser = BehaviorSubject<Bool>(value: false)
        
        input.nickname
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, nickname in
                let valid = owner.isValidNickname(nickname)
                completeButtonUIUpdate.onNext(valid)
                if valid {
                    validNickname.onNext(nickname)
                }
            }
            .disposed(by: disposeBag)

        
        let userInfo = Observable.combineLatest(validEmail, validPassword, validNickname)
            .share()

        
        //MARK: - Join
        input.completeButtonTap
            .withLatestFrom(userInfo)
            .map { email, password, nickname in
                return JoinRequest(email: email, password: password, nick: nickname)
            }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
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
        
        //MARK: - 해당 코드는 반드시 Join이 수행된 이후에 실행된다.
        //MARK: - UserDefault에 저장
        completeJoined
            .withLatestFrom(userInfo)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { email, password, _ in
                return NetworkManager.shared.createLogin(query: LoginRequest(email: email, password: password))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let loginModel):
                    UserDefaultManager.shared.saveAllData(loginResponse: loginModel)
                    completeUser.onNext(true)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            completeButtonUIUpdate: completeButtonUIUpdate.asDriver(onErrorJustReturn: false),
            signUpComplete: completeUser.asDriver(onErrorJustReturn: false)
        )
    }
}
