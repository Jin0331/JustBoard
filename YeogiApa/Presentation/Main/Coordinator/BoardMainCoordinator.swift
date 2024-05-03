//
//  BoardCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import NotificationCenter

final class BoardMainCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(resetLogined), name: .resetLogin, object: nil)
    }
    
    //MARK: -
    func start() {
        let vc = BoardMainViewController(viewControllersList: boardChildViewController(), category: BestCategory.allCases, productId: InquiryRequest.InquiryRequestDefault.productId, limit: InquiryRequest.InquiryRequestDefault.maxLimit)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    @objc func resetLogined(_ notification: Notification) {
        print("토큰초기화됨 ✅")
        parentCoordinator?.resetLogined(self)
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        print(#function, "- BoardCoordinator ✅")
        parentCoordinator?.childDidFinish(self)
    }
}

extension BoardMainCoordinator {
    
    //TODO: - Board Specific Coordinator로 분리해야 됨
    
    func toSpecificBoard(_ item : String) {
        let boardSpecificCoordinator = BoardSpecificCoordinator(navigationController: navigationController)
        boardSpecificCoordinator.parentCoordinator = self
        childCoordinators.append(boardSpecificCoordinator)
        
        boardSpecificCoordinator.start(productId: item,
                                       limit: InquiryRequest.InquiryRequestDefault.limit,
                                       bestBoard: false,
                                       bestBoardType: nil)
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
}

extension BoardMainCoordinator {
    func boardChildViewController() -> Array<RxBaseViewController> {
        
        let category = BestCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        let bestBoard = true
        
        category.forEach {
            let vc = BoardViewController(productId: $0.productId,
                                         limit: InquiryRequest.InquiryRequestDefault.maxLimit,
                                         bestBoard: bestBoard,
                                         bestBoardType: $0
            )
            vc.parentMainCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
}
