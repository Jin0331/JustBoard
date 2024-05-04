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
    var boardDetailCoordinator : BoardDetailCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(userID : String, me : Bool) {
        let vc = ProfileViewController(userID: userID, me: me, viewControllersList: profileChildViewController(userId: userID), category: .profile)
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
    
    private func profileChildViewController(userId : String) -> Array<RxBaseViewController> {
        
        let category = ProfilePostCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        let bestBoard = false
        
        category.forEach {
            let vc = BoardViewController(productId: $0.productId,
                                         userID: userId,
                                         limit: InquiryRequest.InquiryRequestDefault.maxLimit,
                                         bestBoard: false,
                                         profileBoard: true,
                                         bestBoardType: nil,
                                         profileBoardType: $0
            )
            vc.parentPorifleCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
}
