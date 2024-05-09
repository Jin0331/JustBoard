//
//  BoardUserCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit

final class BoardUserCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : BoardMainCoordinator?
    var type: CoordinatorType { .tab }
    
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
    }
}

extension BoardUserCoordinator {
    func toDetail(_ item : PostResponse) {
        let boardDetailCoordinator = BoardDetailCoordinator(navigationController: navigationController)
        boardDetailCoordinator.parentUserBoardCoordinator = self
        boardDetailCoordinator.start(postResponse: item)
        childCoordinators.append(boardDetailCoordinator)
    }
    
    func toProfile(userID : String, me : Bool, defaultPage: Int) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.boardUserCoordinator = self
        profileCoordinator.start(userID: userID, me: me, defaultPage: defaultPage)
        childCoordinators.append(profileCoordinator)
    }
}
