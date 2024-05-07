//
//  AppCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var isLoggedIn : Bool = UserDefaultManager.shared.isLogined
    
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
    
    private func showLoginViewController(isReset : Bool? = nil) {
        let coordinator = UserCoordinator(navigationController: navigationController, isReset: isReset)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    private func showMainViewController() {
        let coordinator = MainTabbarCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    //MARK: - child remove 및 UserCoordinator -> MainTabbarCoordinator
    func didLoggedIn(_ coordinator: UserCoordinator) {
        print(#function, "✅ AppCoordinator")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showMainViewController()
    }
    
    func didJoined(_ coordinator: UserCoordinator) {
        print(#function, "✅ AppCoordinator")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showMainViewController()
    }
    
    func resetLoggedIn(_ coordinator: MainTabbarCoordinator) {
        print(#function, "✅ AppCoordinator")
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        showLoginViewController(isReset: true)
    }
}
