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
    var delegate : MainTabbarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(resetLogined), name: .resetLogin, object: nil)
    }
    
    func start() {
        let vc = BoardMainViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    @objc func resetLogined(_ notification: Notification) {
        print("토큰초기화됨 ✅")
        delegate?.resetLogined(self)
    }
    
    deinit {
        print(#function, "-BoardCoordinator ✅")
    }
}
