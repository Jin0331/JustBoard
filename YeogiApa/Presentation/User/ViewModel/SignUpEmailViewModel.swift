//
//  SignUpEmailViewModel.swift
//  YeogiApa
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
        let nextSuccess : Driver<Bool>
        let nextFailed : Driver<Bool>
        let nextButtonUIUpdate : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let nextSuccess = PublishSubject<Bool>() // 유효성 및 중복되지 않은 이메일
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
            .debug("Email Duplicate Valid")
            .flatMapLatest { email in
                return NetworkManager.shared.validationEmail(query: EmailValidationRequest(email: email))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success():
                    print("email 중복 없음  ✅")
                    nextSuccess.onNext(true)
                case .failure(_):
                    print("email 중복 ❗️")
                    nextFailed.onNext(true)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            nextSuccess: nextSuccess.asDriver(onErrorJustReturn: false),
            nextFailed: nextFailed.asDriver(onErrorJustReturn: false),
            nextButtonUIUpdate: nextButtonUIUpdate.asDriver(onErrorJustReturn: false))
    }
}
