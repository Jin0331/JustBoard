//
//  LoginCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: UserCoordinator)
}

final class UserCoordinator : Coordinator, SignInUpViewControllerDelegate, EmailLoginViewControllerDelegate, SignUpEmailViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var coordinator : LoginCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SignInUpViewController()
        vc.loginDelegate = self
        self.navigationController.viewControllers = [vc]
    }
    
    // User Coordinator -> AppCoordinator -> Main Coordinator로 전환되는 과정
    func login() {
        self.coordinator?.didLoggedIn(self)
    }
    
    // UserCoordinator의 하위 VC
    func kakaoLogin() {
        print("화면전환 ✅ - kakao")
    }
    
    func appleLogin() {
        print("화면전환 ✅ - apple")
    }
    
    func emailLogin() {
        let vc = EmailLoginViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signUp() {
        print("회원가입 ✅")
        let vc = SignUpEmailViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func netxSignUpPasswordVC(email: String) {
        
        print(email)
    }
}
