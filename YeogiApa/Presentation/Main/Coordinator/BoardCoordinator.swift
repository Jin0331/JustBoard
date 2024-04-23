//
//  BoardCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import NotificationCenter

final class BoardCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(resetLogined), name: .resetLogin, object: nil)
    }
    
    func start() {
        let vc = BoardMainViewController()
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    @objc func resetLogined(_ notification: Notification) {
        print("토큰초기화됨 ✅")
        parentCoordinator?.resetLogined(self)
    }
        
    deinit {
        print(#function, "-BoardCoordinator ✅")
    }
}

extension BoardCoordinator {
    
    func toQuestion() {
        let questionCoordinator = QuestionCoordinator(navigationController: navigationController)
        questionCoordinator.parentCoordinator = self
        questionCoordinator.start()
        childCoordinators.append(questionCoordinator)
    }
    
    func toBoard(_ coordinator: QuestionCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        print(#function, childCoordinators, "✅ BoardCoordinator")
    }
}
