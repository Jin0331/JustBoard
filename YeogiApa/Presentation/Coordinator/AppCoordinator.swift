//
//  AppCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if self.isLoggedIn {
            showMainViewController()
        } else {
            showLoginViewController()
        }
    }
    
    private func showLoginViewController() {
        let coordinator = UserCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    private func showMainViewController() {
        
    }
    
    // child remove
    func didLoggedIn(_ coordinator: UserCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showMainViewController()
    }
    
    func joined(_ coordinator: UserCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showMainViewController()
    }
}
