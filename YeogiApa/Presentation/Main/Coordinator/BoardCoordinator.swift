//
//  BoardCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import NotificationCenter

final class BoardCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(resetLogined), name: .resetLogin, object: nil)
    }
    
    func start() {
        let vc = BoardMainViewController(viewControllersList: boardChildViewController(), category: Category.allCases, productId: InquiryRequest.InquiryRequestDefault.productId, limit: InquiryRequest.InquiryRequestDefault.maxLimit)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    @objc func resetLogined(_ notification: Notification) {
        print("토큰초기화됨 ✅")
        parentCoordinator?.resetLogined(self)
    }
        
    deinit {
        print(#function, "-BoardCoordinator ✅")
    }
}

extension BoardCoordinator {
    
    func toQuestion() {
        let questionCoordinator = QuestionCoordinator(navigationController: navigationController)
        questionCoordinator.parentCoordinator = self
        questionCoordinator.start()
        childCoordinators.append(questionCoordinator)
    }
    
    func toBoard(_ coordinator: QuestionCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        print(#function, childCoordinators, "✅ BoardCoordinator")
    }
    
    func toDetail(_ item : PostResponse) {
        let vc = BoardDetailViewController(postResponse: item)
        vc.parentCoordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension BoardCoordinator {
    func boardChildViewController() -> Array<RxBaseViewController> {
        
        let category = Category.allCases
        var viewControllersList: Array<RxBaseViewController> = []
        var bestBoard = true
        
        category.forEach {
            let vc = BoardViewController(productId: $0.productId,
                                         limit: InquiryRequest.InquiryRequestDefault.maxLimit,
                                         bestBoard: bestBoard)
            vc.parentCoordinator = self
            viewControllersList.append(vc)
        }
        
        return viewControllersList
    }
}
