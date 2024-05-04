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
    private let baseView : ProfileView
    private let viewModel : ProfileViewModel
    var parentCoordinator : ProfileCoordinator?
    
    init(userID: String, me: Bool, viewControllersList : Array<RxBaseViewController>, category : [BestCategory]) {
        self.me = me
        self.viewModel = ProfileViewModel(userID: BehaviorSubject<String>(value: userID))
        let tabmanVC = BoardTabmanViewController(viewControllersList: viewControllersList, category: category)
        self.baseView = ProfileView(tabmanViewController: tabmanVC, me: me)
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func bind() {
        
        let input = ProfileViewModel.Input(viewWillAppear: rx.viewWillAppear)
        
        let output = viewModel.transform(input: input)
        
        output.userProfile
            .bind(with: self) { owner, profileResponse in
                owner.baseView.updateUI(profileResponse)
            }
            .disposed(by: disposeBag)
        
        
    }

    deinit {
        print(#function, "ProfileViewController ✅")
    }
}
