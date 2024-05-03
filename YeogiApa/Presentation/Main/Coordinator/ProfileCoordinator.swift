//
//  ProfileCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit

final class ProfileCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : BoardMainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProfileViewController()
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}
