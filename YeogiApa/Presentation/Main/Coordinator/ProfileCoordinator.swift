//
//  ProfileCoordinator.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit

final class ProfileCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var boardMainCoordinator : BoardMainCoordinator?
    var boardSpecificCoordinator : BoardSpecificCoordinator?
    var boardUserCoordinator : BoardUserCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(userID : String, me : Bool) {
        let vc = ProfileViewController(userID: userID, me: me)
        vc.parentCoordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}