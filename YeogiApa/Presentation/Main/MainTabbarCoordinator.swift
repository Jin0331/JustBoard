//
//  MainCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit

final class MainTabbarCoordinator : Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var delegate : AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabbarController = UITabBarController()
        
        // First Tab - Board
        let boardItem = UITabBarItem()
        boardItem.title = "홈"
        boardItem.image = UIImage.init(systemName: "house")
        
        let boardNavigationController = UINavigationController()
        boardNavigationController.tabBarItem = boardItem
        
        let boardCoordinator = BoardCoordinator(navigationController: boardNavigationController)
        boardCoordinator.delegate = self
        
        // Second Tab - Setting
        let settingItem = UITabBarItem()
        settingItem.title = "더 보기"
        settingItem.image = UIImage.init(systemName: "person.fill")
        
        let settingNavigationController = UINavigationController()
        settingNavigationController.tabBarItem = settingItem
        
        let settingCoordinator = SettingCoordinator(navigationController: settingNavigationController)
        settingCoordinator.delegate = self
        
        // tabbar 설정 및 child 추가
        tabbarController.viewControllers = [boardNavigationController, settingNavigationController]
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
        
        childCoordinators.append(boardCoordinator)
        childCoordinators.append(settingCoordinator)
        
        boardCoordinator.start()
        settingCoordinator.start()
    }
    
}
