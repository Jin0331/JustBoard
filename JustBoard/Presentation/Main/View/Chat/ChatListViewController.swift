//
//  ChatListViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import UIKit

class ChatListViewController: RxBaseViewController {
    var parentCoordinator : ChatListCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = .red
    }
}
