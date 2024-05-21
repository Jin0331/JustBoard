//
//  ChatCoordinator.swift
//  JustBoard
//
//  Created by JinwooLee on 5/21/24.
//

import UIKit
import SwiftUI

final class ChatCoordinator : Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentChatListCoordinator : ChatListCoordinator?
    var parentProfileCoordinator : ProfileCoordinator?
    var parentMainCoordinator : BoardMainCoordinator?
    var type: CoordinatorType { .tab }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(chat : ChatResponse) {
        var childView = ChatView(chat: chat)
        childView.parentCoordinator = self
        
        let myId = UserDefaultManager.shared.userId
        let oppentNickname = chat.participants[0].userID == myId ? chat.participants[1].nick : chat.participants[0].nick
        let vc = ChatViewController(contentViewController: UIHostingController(rootView: childView), navigationTitle: oppentNickname)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
