//
//  ProfileCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit

final class ProfileCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var boardMainCoordinator : BoardMainCoordinator?
    var boardSpecificCoordinator : BoardSpecificCoordinator?
    var boardUserCoordinator : BoardUserCoordinator?
    var boardDetailCoordinator : BoardDetailCoordinator?
    var followCoordinator : FollowCoordinator?
    var chatListCoordinator : ChatListCoordinator?
    var type: CoordinatorType { .tab }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(userID : String, me : Bool, defaultPage: Int) {
        let vc = ProfileViewController(userID: userID, me: me, viewControllersList: profileChildViewController(userId: userID), category: .profile)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension ProfileCoordinator {
    
    func toProfileEdit(_ profileResponse : ProfileResponse) {
        let vc = ProfileEditViewController(meProfileResponse: profileResponse)
        vc.parentCoordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toDetail(_ item : PostResponse) {
        let boardDetailCoordinator = BoardDetailCoordinator(navigationController: navigationController)
        boardDetailCoordinator.parentProfileCoordinator = self
        boardDetailCoordinator.start(postResponse: item)
        childCoordinators.append(boardDetailCoordinator)
    }
    
    func toFollow(_ item : ProfileResponse, _ me : Bool, _ defaultPage : Int) {
        let followCoordinator = FollowCoordinator(navigationController: navigationController)
        followCoordinator.parentCoordinator = self
        followCoordinator.start(userID: item.user_id, userNickname: item.nick, me: me, defaultPage: defaultPage)
        childCoordinators.append(followCoordinator)
    }
    
    func toChat(chat : ChatResponse) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        chatCoordinator.parentProfileCoordinator = self
        chatCoordinator.start(chat: chat)
        childCoordinators.append(chatCoordinator)
    }
    
    private func profileChildViewController(userId : String) -> Array<RxBaseViewController> {
        
        let category = ProfilePostCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        
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
