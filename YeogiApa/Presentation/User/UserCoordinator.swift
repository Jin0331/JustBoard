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

final class UserCoordinator : Coordinator, LoginViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var loginDelegate: LoginCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SignInUpViewController()
        self.navigationController.viewControllers = [viewController]
    }
    
    func login() {
        self.loginDelegate?.didLoggedIn(self)
    }
}
