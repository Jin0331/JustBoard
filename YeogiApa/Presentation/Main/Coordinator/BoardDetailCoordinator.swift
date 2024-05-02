//
//  BoardDetailCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit

final class BoardDetailCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentMainBoardCoordinator : BoardMainCoordinator?
    var parentSpecificBoardCoordinator : BoardSpecificCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(postResponse : PostResponse) {
        let vc = BoardDetailViewController(postResponse: postResponse)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, "- BoardDetailCoordinator ✅")
        parentMainBoardCoordinator?.childDidFinish(self)
        parentSpecificBoardCoordinator?.childDidFinish(self)
    }
}
