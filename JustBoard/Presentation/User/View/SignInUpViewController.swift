//
//  SignInUpViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationCenter
import AuthenticationServices

final class SignInUpViewController : RxBaseViewController{
    
    private let baseView = SignInUpView()
    private let viewModel = SignUpThirdPartyViewModel()
    private var isReset : Bool?
    private let thirdPartyEmail : PublishSubject<String>
    private let thirdPartyPassword: PublishSubject<String>
    private let thirdPartyNick : BehaviorSubject<String>
    var parentCoordinator : UserCoordinator?

    
    init(isReset: Bool? = nil) {
        self.isReset = isReset
        self.thirdPartyEmail = PublishSubject<String>()
        self.thirdPartyPassword = PublishSubject<String>()
        self.thirdPartyNick = BehaviorSubject<String>(value: "")
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        print(#function, "SignInUpViewController✅")

        if let isReset, isReset == true {
            showAlert(title: "로그인 세션 만료", text: "다시 로그인 해주세요 🥲", addButtonText: "확인")
        }
    }
    
    override func bind() {
        baseView.appleLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
                       
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
            .disposed(by: disposeBag)
        
        baseView.emailLoginButton.rx
            .tap
            .bind(with: self) { owner, _ in
                print("hi")
                owner.parentCoordinator?.emailLogin()
            }
            .disposed(by: disposeBag)
        
        
        let input = SignUpThirdPartyViewModel.Input(email: thirdPartyEmail, password: thirdPartyPassword, nick: thirdPartyNick)
        
        let output = viewModel.transform(input: input)
        
        output.complete
            .bind(with: self) { owner, _ in
                owner.parentCoordinator?.didLoggedIn()
                owner.parentCoordinator?.finish()
            }
            .disposed(by: disposeBag)
        
    }
    
    func getFontName() {
        for family in UIFont.familyNames {

            let sName: String = family as String
            print("family: \(sName)")
                    
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
    }
    
    deinit {
        print(#function, "SignInUpViewController✅")
    }
    
}

extension SignInUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        // MARK: - 이메일
        // 첫 로그인
        // credential.email를 통한 분기처리
        if let email = credential.email {
            let userIdentifier = credential.user
            
            thirdPartyEmail.onNext(userIdentifier)
            thirdPartyPassword.onNext(userIdentifier)
            thirdPartyNick.onNext(Utils.randomNickname())
            
        } else {
            // credential.identityToken은 jwt로 되어있고, 해당 토큰을 decode 후 email에 접근해야한다.
            if let tokenString = String(data: credential.identityToken ?? Data(), encoding: .utf8) {
                let userIdentifier = Utils.decode(jwtToken: tokenString)["sub"] as? String ?? ""
                
                thirdPartyEmail.onNext(userIdentifier)
                thirdPartyPassword.onNext(userIdentifier)
                thirdPartyNick.onNext(Utils.randomNickname())
            }
        }
    }
    

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
