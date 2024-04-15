//
//  Protocol.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import Foundation

protocol Coordinator : AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}
