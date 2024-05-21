//
//  BoardCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import NotificationCenter

final class BoardMainCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .vc }
    var navigationController: UINavigationController
    var parentCoordinator : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(resetLogined), name: .resetLogin, object: nil)
    }
    
    //MARK: -
    func start() {
        let vc = BoardMainViewController(bestViewControllersList: boardChildViewController(), userViewControllerList: boardUserChildViewController())
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, "- BoardCoordinator ✅")
    }
}

extension BoardMainCoordinator {
    
    func toSpecificBoard(_ item : String) {
        let boardSpecificCoordinator = BoardSpecificCoordinator(navigationController: navigationController)
        boardSpecificCoordinator.parentBoardCoordinator = self
        childCoordinators.append(boardSpecificCoordinator)
        
        boardSpecificCoordinator.start(productId: item,
                                       limit: InquiryRequest.InquiryRequestDefault.limit,
                                       bestBoard: false,
                                       profileBoard: false
        )
    }
    
    func toDetail(_ item : PostResponse) {
        let boardDetailCoordinator = BoardDetailCoordinator(navigationController: navigationController)
        boardDetailCoordinator.parentMainBoardCoordinator = self
        boardDetailCoordinator.start(postResponse: item)
        childCoordinators.append(boardDetailCoordinator)
    }
    
    func toUser(_ item : ([String], String)) {
        let boardUserCoordinator = BoardUserCoordinator(navigationController: navigationController)
        boardUserCoordinator.parentCoordinator = self
        boardUserCoordinator.start(userProfile: item)
        childCoordinators.append(boardUserCoordinator)
    }
    
    func toProfile(userID : String, me : Bool, defaultPage : Int) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.boardMainCoordinator = self
        profileCoordinator.start(userID: userID, me: me, defaultPage: defaultPage)
        childCoordinators.append(profileCoordinator)
    }
    
    func toChatList(chatlist: MyChatResponse) {
        let chatListCoordinaotr = ChatListCoordinator(navigationController: navigationController)
        chatListCoordinaotr.parentBoardCoordinator = self
        chatListCoordinaotr.start(chatlist: chatlist)
        childCoordinators.append(chatListCoordinaotr)
    }
    
    
    @objc func resetLogined(_ notification: Notification) {
        print("토큰초기화됨 ✅")
        parentCoordinator?.finish()
        parentCoordinator?.resetLogined()
    }
}

extension BoardMainCoordinator {
    
    func toChat(chat : ChatResponse) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        chatCoordinator.parentMainCoordinator = self
        chatCoordinator.start(chat: chat)
        childCoordinators.append(chatCoordinator)
    }
    
    private func boardChildViewController() -> Array<RxBaseViewController> {
        
        let category = BestCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        let bestBoard = true
        let profileBoard = false
        
        category.forEach {
            let vc = BoardViewController(productId: $0.productId,
                                         limit: InquiryRequest.InquiryRequestDefault.maxLimit,
                                         bestBoard: bestBoard,
                                         profileBoard: profileBoard,
                                         bestBoardType: $0
            )
            vc.parentMainCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
    
    private func boardUserChildViewController() -> Array<RxBaseViewController> {
        
        let category = BestUserCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        
        category.forEach {
            let vc = BoardRankViewController(productId: $0.productId, limit:InquiryRequest.InquiryRequestDefault.maxLimit, boardType: $0)
            
            vc.parentCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
}
