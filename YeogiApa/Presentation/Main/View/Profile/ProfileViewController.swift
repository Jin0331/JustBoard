//
//  ProfileViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: RxBaseViewController {

//    let baseView :
    var parentCoordinator : ProfileCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
    }

    deinit {
        print(#function, "ProfileViewController ✅")
    }
}
