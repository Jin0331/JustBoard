//
//  MainCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import Foundation
import UIKit

final class MainCoordinator : Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var delegate : AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController()
        self.navigationController.viewControllers = [vc]
    }
    
    
}
