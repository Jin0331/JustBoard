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
    
    func start() { }
    
    func start(chatlist : MyChatResponse) {
        
        var childView = ChatListView(chatList: chatlist)
        childView.parentCoordinator = self
        let vc = ChatListViewController(contentViewController: UIHostingController(rootView: childView))
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension ChatListCoordinator {
    func toChat(chat : ChatResponse) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        chatCoordinator.parentChatListCoordinator = self
        chatCoordinator.start(chat: chat)
        childCoordinators.append(chatCoordinator)
    }
}
