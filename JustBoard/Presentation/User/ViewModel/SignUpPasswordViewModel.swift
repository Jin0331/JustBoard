//
//  SignUpPasswordViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpPasswordViewModel : UserViewModelType {
    
    var email : String
    var disposeBag: DisposeBag = DisposeBag()
    
    init(email: String) {
        self.email = email
    }
    
    struct Input {
        let password : ControlProperty<String>
        let passwordVerfy : ControlProperty<String>
        let nextButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let validEmailPassword : Observable<(String,String)>
        let nextButtonUIUpdate : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonUIUpdate = BehaviorSubject<Bool>(value: false) // 유효성 검증
        let email = BehaviorSubject<String>(value: email)
        
        //MARK: - 유효성 검사
        let passwordValid = Observable.combineLatest(input.password.asObservable(), input.passwordVerfy.asObservable())
            .map { [weak self] password, passwordVerify in
                guard let self = self else { return false }
                let valid = self.isValidPassword(password) && self.isValidPassword(passwordVerify)
                let equal = isEqualPassword(password, passwordVerify)
                return valid && equal
            }
  
        passwordValid
            .throttle(.milliseconds(700), scheduler: MainScheduler.instance)
            .bind(to: nextButtonUIUpdate)
            .disposed(by: disposeBag)
        
        //MARK: - 검증 완료된 이메일 비밀번호
        let emailPassword = Observable.combineLatest(email.asObservable(),
                                                     input.nextButtonTap.withLatestFrom(input.password).asObservable())

        return Output(
            validEmailPassword: emailPassword,
            nextButtonUIUpdate:nextButtonUIUpdate.asDriver(onErrorJustReturn: false))
    }
}
