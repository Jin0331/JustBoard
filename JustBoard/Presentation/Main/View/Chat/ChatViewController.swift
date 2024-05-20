//
//  ChatViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/21/24.
//

import UIKit
import SwiftUI
import SnapKit

final class ChatViewController: RxBaseViewController {
    let contentViewController : UIHostingController<ChatView>
    let navigationTitle : String
    
    init(contentViewController: UIHostingController<ChatView>, navigationTitle : String) {
        self.contentViewController = contentViewController
        self.navigationTitle = navigationTitle
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureNavigation() {
        navigationItem.title = navigationTitle
    }
}
