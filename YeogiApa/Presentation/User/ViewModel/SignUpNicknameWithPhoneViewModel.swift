//
//  SignUpNicknameWithPhoneViewModel.swift
//  YeogiApa
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
        let signUpComplete : Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validEmail = BehaviorSubject<String>(value: email)
        let validPassword = BehaviorSubject<String>(value: password)
        let validNickname = PublishSubject<String>()
        let completeButtonUIUpdate = BehaviorSubject<Bool>(value: false)
        
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
            .map { email, password, nickname in
                return JoinRequest(email: email, password: password, nick: nickname)
            }
        
        input.completeButtonTap
            .withLatestFrom(userInfo)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { joinQuery in
                return NetworkManager.shared.createJoin(query: joinQuery)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let joinModel):
                    print(joinModel)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            completeButtonUIUpdate: completeButtonUIUpdate.asDriver(onErrorJustReturn: false),
            signUpComplete: Observable.just(false)
        )
    }
}
