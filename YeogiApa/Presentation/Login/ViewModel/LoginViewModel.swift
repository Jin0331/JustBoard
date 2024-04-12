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
        let loginButtonUIUpdate : Driver<Bool>
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
            .debug("ButtonUI")
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
                      loginFailed: loginFailed.asDriver(onErrorJustReturn: false),
                      loginButtonUIUpdate: loginButtonUIUpdate.asDriver(onErrorJustReturn: false)
        )
        
    }
    
    deinit {
        print(#function, "-LoginViewModel 🔆")
    }
    
    
}

//MARK: - 유효성 검증
extension LoginViewModel {
    
    private func matchesPattern(_ string : String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, options: [], range: range) != nil
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
            return false
        }
    }
    
    private func isValidEmail(_ email : String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return matchesPattern(email, pattern: emailPattern)
    }
    
    // 최소 8 자 및 최대 15 자, 하나 이상의 대문자/소문자/숫자/특수 문자 정규식
    private func isValidPassword(_ password : String) -> Bool {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\\.@$!%*?&])[A-Za-z\\d\\.@$!%*?&]{8,15}$"
        return matchesPattern(password, pattern: passwordPattern)
    }
}
