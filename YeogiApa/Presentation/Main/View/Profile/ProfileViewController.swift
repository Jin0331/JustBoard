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

//    private let userID : BehaviorSubject<String>
    private let me : Bool
    private let baseView = ProfileView()
    private let viewModel : ProfileViewModel
    var parentCoordinator : ProfileCoordinator?
    
    init(userID: String, me: Bool) {
        self.me = me
        self.viewModel = ProfileViewModel(userID: BehaviorSubject<String>(value: userID))
    }
    
    override func loadView() {
        view = baseView
    }
    
    
    
    override func bind() {
        
        let input = ProfileViewModel.Input(viewWillAppear: rx.viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
        output.userProfile
            .bind(with: self) { owner, profileResponse in
                print(profileResponse)
            }
            .disposed(by: disposeBag)
        
        
    }

    deinit {
        print(#function, "ProfileViewController ✅")
    }
}
