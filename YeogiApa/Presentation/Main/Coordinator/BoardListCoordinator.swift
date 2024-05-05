//
//  BoardListCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit

final class BoardListCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = BoardListTabmanViewController(viewControllersList: childViewController(), category: BoardListCategory.allCases)
        self.navigationController.pushViewController(vc, animated: true)
        vc.parentCoordinator = self
    }
    
    deinit {
        print(#function, "-SettingCoordinator ✅")
    }
    
}

extension BoardListCoordinator {
    
    func toSpecificBoard(_ item : String) {
        let boardSpecificCoordinator = BoardSpecificCoordinator(navigationController: navigationController)
        boardSpecificCoordinator.parentBoardListCoordinator = self
        childCoordinators.append(boardSpecificCoordinator)
        
        boardSpecificCoordinator.start(productId: item,
                                       limit: InquiryRequest.InquiryRequestDefault.limit,
                                       bestBoard: false,
                                       profileBoard: false
        )
    }
    
    private func childViewController() -> Array<RxBaseViewController> {
        
        let category = BoardListCategory.allCases
        var viewControllersList: Array<RxBaseViewController> = []

        category.forEach {
            let vc = BoardListViewController(productId: $0.productId, specificBoard: $0.specificBoard)
            vc.parentCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
}
