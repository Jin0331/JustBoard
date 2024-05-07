//
//  LoginCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation
import UIKit

final class UserCoordinator : Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var isReset : Bool?
    var delegate : AppCoordinator?
    
    init(navigationController: UINavigationController, isReset: Bool? = nil) {
        self.navigationController = navigationController
        self.isReset = isReset
    }
    
    func start() {
        let vc = SignInUpViewController(isReset: isReset) // child root view controller
        vc.parentCoordinator = self
        self.navigationController.viewControllers = [vc]
    }
    
    // User Coordinator -> AppCoordinator -> Main Coordinator로 전환되는 과정
    func didLoggedIn(_ coordinator : EmailLoginCoordinator) {
        print(#function, "✅ UserCoordinator")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        delegate?.didLoggedIn(self)
    }
    
    func didJoined(_ coordinator : EmailLoginCoordinator) {
        print(#function, "✅ UserCoordinator")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        delegate?.didJoined(self)
    }
    
    // UserCoordinator의 하위 VC
    func kakaoLogin() {
        print("화면전환 ✅ - kakao")
    }
    
    func appleLogin() {
        print("화면전환 ✅ - apple")
    } 
    
    func emailLogin() {
        let child = EmailLoginCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    deinit {
        print(#function, "- UserCoordinator ✅")
    }

}
