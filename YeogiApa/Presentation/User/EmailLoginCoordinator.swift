//
//  EmailLoginCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/16/24.
//

import UIKit

final class EmailLoginCoordinator : Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate : UserCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = EmailLoginViewController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didLogined() {
        print(#function, "✅ EmailLCoordinator")
        delegate?.didLoggedIn(self)
    }
    
    func didJoined() {
        delegate?.didJoined(self)
    }
    
    deinit {
        print(#function, "- EmailLoginCoordinator ✅")
    }
}

//MARK: - 소속된 VC간 화면전환.. VC당 child Coordinator를 만들면 좋겠지만,,,
extension EmailLoginCoordinator {
    
    func emailLogin() {
        let vc = EmailLoginViewController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signUp() {
        print("회원가입 ✅")
        let vc = SignUpEmailViewController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func netxSignUpPasswordVC(email: String) {
        let vc = SignUpPasswordViewController(email:email)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signUpCompleted(email: String, password: String) {
        let vc = SignUpNicknameWithPhoneViewController(email: email, password: password)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
