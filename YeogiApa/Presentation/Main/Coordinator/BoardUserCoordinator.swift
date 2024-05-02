//
//  BoardUserCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit

final class BoardUserCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : BoardMainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(userPost : [PostResponse]) {
        let vc = BoardUserViewController(userPost: userPost)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, "- BoardDetailCoordinator ✅")
        parentCoordinator?.childDidFinish(self)
    }
}
