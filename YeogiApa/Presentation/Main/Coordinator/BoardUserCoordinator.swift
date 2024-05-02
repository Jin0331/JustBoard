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
    
    func start(userProfile : (userPostId:[String], userNickname:String)) {
        let vc = BoardUserViewController(userProfile: userProfile)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, "- BoardDetailCoordinator ✅")
        parentCoordinator?.childDidFinish(self)
    }
}

extension BoardUserCoordinator {
    func toDetail(_ item : PostResponse) {
        let boardDetailCoordinator = BoardDetailCoordinator(navigationController: navigationController)
        boardDetailCoordinator.parentUserBoardCoordinator = self
        boardDetailCoordinator.start(postResponse: item)
        childCoordinators.append(boardDetailCoordinator)
    }
}
