//
//  ChatListViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxViewController

class ChatListViewController: RxBaseViewController {
    var parentCoordinator : ChatListCoordinator?
    let contentViewController : UIHostingController<ChatListView>
    
    init(contentViewController: UIHostingController<ChatListView>) {
        self.contentViewController = contentViewController
    }
    
    override func bind() {
        rx.viewWillAppear
            .flatMap { _ in
                return NetworkManager.shared.myChatList()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myChatResponse):
                    dump(myChatResponse)
                case .failure(_):
                    print("error")
                }
            }
            .disposed(by: disposeBag)
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
