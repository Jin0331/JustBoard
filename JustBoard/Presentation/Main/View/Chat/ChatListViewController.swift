//
//  ChatListViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import UIKit
import SwiftUI
import SnapKit

class ChatListViewController: RxBaseViewController {
    var parentCoordinator : ChatListCoordinator?
    let contentViewController : UIHostingController<ChatListView>
    
    init(contentViewController: UIHostingController<ChatListView>) {
        self.contentViewController = contentViewController
    }
    
    override func configureHierarchy() {
        view.addSubview(contentViewController.view)
    }
    
    override func configureLayout() {
        contentViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = DesignSystem.commonColorSet.white
    }
    
}
