//
//  SignUpEmailViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpEmailViewModel : UserViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let email : ControlProperty<String>
        let nextButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let validEmail : Driver<String>
        let nextFailed : Driver<Bool>
        let nextButtonUIUpdate : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validEmail = PublishSubject<String>() // 유효성 및 중복되지 않은 이메일
        let nextFailed = PublishSubject<Bool>() // 중복된 이메일인 경우
        let nextButtonUIUpdate = BehaviorSubject<Bool>(value: false) // 유효성 검증
        
        //MARK: - 이메일 유효성 검사
        input.email
            .bind(with: self) { owner, email in
                let valid = owner.isValidEmail(email)
                nextButtonUIUpdate.onNext(valid)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .withLatestFrom(input.email)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { email in
                return NetworkManager.shared.validationEmail(query: EmailValidationRequest(email: email))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let email):
                    print("email 중복 없음  ✅")
                    validEmail.onNext(email)
                case .failure:
                    print("email 중복 ❗️")
                    nextFailed.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            validEmail : validEmail.asDriver(onErrorJustReturn: ""),
            nextFailed: nextFailed.asDriver(onErrorJustReturn: false),
            nextButtonUIUpdate: nextButtonUIUpdate.asDriver(onErrorJustReturn: false))
    }
}
