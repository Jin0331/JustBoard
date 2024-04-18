//
//  Protocol.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
