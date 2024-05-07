//
//  MainCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit

final class MainTabbarCoordinator : Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var parentCoordinator : AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(goToMain), name: .goToMain, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToBoard), name: .goToBoard, object: nil)
    }
    
    func start() {
        let tabbarController = MainTabBarController()
        
        let boardNavigationController = UINavigationController()
        let boardCoordinator = BoardMainCoordinator(navigationController: boardNavigationController)
        boardCoordinator.parentCoordinator = self
        
        
        let boardListNavigationController = UINavigationController()
        let boardListCoordinator = BoardListCoordinator(navigationController: boardListNavigationController)
        boardListCoordinator.parentCoordinator = self
        
        // tabbar 설정 및 child 추가
        tabbarController.viewControllers = [boardNavigationController, boardListNavigationController]
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
        
        childCoordinators.append(boardCoordinator)
        childCoordinators.append(boardListCoordinator)
        
        boardCoordinator.start()
        boardListCoordinator.start()
    }
    
    deinit {
        print(#function, "-MainTabbarCoordinator ✅")
    }
    
}

extension MainTabbarCoordinator {
    func resetLogined(_ coordinator : BoardMainCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        parentCoordinator?.resetLoggedIn(self)
        parentCoordinator?.childDidFinish(self)
    }
    
    @objc func goToMain(_ notification: Notification) {
        print("gotohome ✅")
        
        guard let tabBarController = UIApplication.shared.tabbarController() as? MainTabBarController else { return }
        
        if tabBarController.selectedIndex != 0 {
            tabBarController.selectedIndex = 0
        } else {
            if let navController = tabBarController.viewControllers?.first as? UINavigationController {
                navController.popToRootViewController(animated: false)
            }
        }
    }
    
    @objc func goToBoard(_ notification: Notification) {
        print("gotoBoard ✅")
        
        guard let tabBarController = UIApplication.shared.tabbarController() as? MainTabBarController else { return }
        
        if tabBarController.selectedIndex != 1 {
            tabBarController.selectedIndex = 1
        } else {
            if let navController = tabBarController.viewControllers?.first as? UINavigationController {
                navController.popToRootViewController(animated: false)
            }
        }
    }
}
