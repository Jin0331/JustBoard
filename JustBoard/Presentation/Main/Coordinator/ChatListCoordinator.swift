//
//  ChatListCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import UIKit
import SwiftUI

final class ChatListCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentBoardCoordinator : BoardMainCoordinator?
    var type: CoordinatorType { .tab }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ChatListViewController(contentViewController: UIHostingController(rootView: ChatListView()))
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
