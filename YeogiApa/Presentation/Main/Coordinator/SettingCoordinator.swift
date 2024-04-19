//
//  SettingCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit

final class SettingCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, "-SettingCoordinator ✅")
    }
    
}
