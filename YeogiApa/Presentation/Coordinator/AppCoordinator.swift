//
//  AppCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator, LoginCoordinatorDelegate {

    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if self.isLoggedIn {
            self.showMainViewController()
        } else {
            self.showLoginViewController()
        }
    }
    
    private func showLoginViewController() {
        let coordinator = UserCoordinator(navigationController: self.navigationController)
        coordinator.coordinator = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showMainViewController() {
        //
    }
    
    func didLoggedIn(_ coordinator: UserCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainViewController()
    }
}
