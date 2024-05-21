//
//  BoardSpecificCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 5/2/24.
//

import UIKit
import NotificationCenter

final class BoardSpecificCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentBoardCoordinator : BoardMainCoordinator?
    var parentBoardListCoordinator : BoardListCoordinator?
    var type: CoordinatorType { .tab }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func start(productId : String, limit : String, bestBoard: Bool, profileBoard: Bool) {
        let vc = BoardViewController(productId: productId,
                                     limit: InquiryRequest.InquiryRequestDefault.limit,
                                     bestBoard: bestBoard, 
                                     profileBoard: profileBoard)
                                        
        vc.parentCoordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, "BoardSpecificCoordinator ✅")
    }
}

extension BoardSpecificCoordinator {
    func toQuestion(_ productId : String) {
        let questionCoordinator = QuestionCoordinator(navigationController: navigationController)
        questionCoordinator.parentCoordinator = self
        questionCoordinator.start(productId: productId)
        childCoordinators.append(questionCoordinator)
    }
    
    func toBoard(_ coordinator: QuestionCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        print(#function, childCoordinators, "✅ BoardCoordinator")
    }
    
    func toDetail(_ item : PostResponse) {
        let boardDetailCoordinator = BoardDetailCoordinator(navigationController: navigationController)
        boardDetailCoordinator.parentSpecificBoardCoordinator = self
        boardDetailCoordinator.start(postResponse: item)
        childCoordinators.append(boardDetailCoordinator)
    }

    func toSpecificBoard(_ item : String) {
        let vc = BoardViewController(productId: item,
                                     limit: InquiryRequest.InquiryRequestDefault.limit,
                                     bestBoard: false, 
                                     profileBoard: false)


        vc.parentCoordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toProfile(userID : String, me : Bool, defaultPage:Int) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.boardSpecificCoordinator = self
        profileCoordinator.start(userID: userID, me: me, defaultPage: defaultPage)
        childCoordinators.append(profileCoordinator)
    }
}
