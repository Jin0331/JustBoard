//
//  QuestionCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 4/19/24.
//

import UIKit

final class QuestionCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : BoardSpecificCoordinator?
    var type: CoordinatorType { .tab }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(productId : String) {
        let vc = QuestionViewController(productId: productId)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension QuestionCoordinator {
    func toBaord() {
        parentCoordinator?.toBoard(self)
    }
}
