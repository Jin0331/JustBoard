//
//  BoardDetailCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit

final class BoardDetailCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    var navigationController: UINavigationController
    var parentProfileCoordinator : ProfileCoordinator?
    var parentMainBoardCoordinator : BoardMainCoordinator?
    var parentSpecificBoardCoordinator : BoardSpecificCoordinator?
    var parentUserBoardCoordinator : BoardUserCoordinator?
    
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
    }
}

extension BoardDetailCoordinator {
    func toProfile(userID : String, me : Bool) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.boardDetailCoordinator = self
        profileCoordinator.start(userID: userID, me: me, defaultPage: 0)
        childCoordinators.append(profileCoordinator)
    }
}
