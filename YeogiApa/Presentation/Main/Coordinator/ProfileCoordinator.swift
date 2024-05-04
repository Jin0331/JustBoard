//
//  ProfileCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit

final class ProfileCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var boardMainCoordinator : BoardMainCoordinator?
    var boardSpecificCoordinator : BoardSpecificCoordinator?
    var boardUserCoordinator : BoardUserCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(userID : String, me : Bool) {
        let vc = ProfileViewController(userID: userID, me: me, viewControllersList: profileChildViewController(), category: .profile)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension ProfileCoordinator {
    
    func toDetail(_ item : PostResponse) {
        let boardDetailCoordinator = BoardDetailCoordinator(navigationController: navigationController)
        boardDetailCoordinator.parentProfileCoordinator = self
        boardDetailCoordinator.start(postResponse: item)
        childCoordinators.append(boardDetailCoordinator)
    }
    
    func profileChildViewController() -> Array<RxBaseViewController> {
        
        let category = BestCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        let bestBoard = false
        
        category.forEach {
            let vc = BoardViewController(productId: $0.productId,
                                         limit: InquiryRequest.InquiryRequestDefault.maxLimit,
                                         bestBoard: bestBoard,
                                         bestBoardType: $0
            )
            vc.parentPorifleCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
}
