//
//  ProfileEditViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/9/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditViewController: RxBaseViewController {
    
    private let baseView = ProfileEditView()
    var parentCoordinator : ProfileCoordinator?
    let meProfileResponse : ProfileResponse
    
    init(meProfileResponse: ProfileResponse) {
        self.meProfileResponse = meProfileResponse
    }
    
    override func loadView() {
        view = baseView
    }

    
    override func configureView() {
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationItem.title = "프로필 수정"
    }
}

