//
//  Protocol.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {

            print("childDidFinish")
            
            // ✅ === 연산자는 클래스의 두 인스턴스가 동일한 메모리를 가리키는지에 대한 연산(그래서 === 연산자를 사용하기 위해서 Coordinator 를 클레스 전용 프로토콜(class-only protocol) 로 만들어준다.)
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
