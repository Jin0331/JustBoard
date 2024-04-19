//
//  QuestionCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit

final class QuestionCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var delegate : BoardCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = QuestionViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
