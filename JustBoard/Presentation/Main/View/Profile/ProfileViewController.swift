//
//  ProfileViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: RxBaseViewController {

    private let me : Bool
    private let baseView : ProfileView
    private let viewModel : ProfileViewModel
    var parentCoordinator : ProfileCoordinator?
    
    init(userID: String, me: Bool, viewControllersList : Array<RxBaseViewController>, category : TabmanCategory) {
        self.me = me
        self.viewModel = ProfileViewModel(userID: BehaviorSubject<String>(value: userID), me: me)
        let tabmanVC = BoardTabmanViewController(viewControllersList: viewControllersList, category: category)
        self.baseView = ProfileView(tabmanViewController: tabmanVC, me: me)
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func bind() {
        
        
        let input = ProfileViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            profileEditButton: baseView.profileEditButton.rx.tap,
            followButton: baseView.followButton.rx.tap,
            followerCountButton: baseView.followerCountButton.rx.tap,
            followingCountButton: baseView.followingCountButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)
        
        output.profileEditButton
            .bind(with: self) { owner, profileResponse in
                owner.parentCoordinator?.toProfileEdit(profileResponse)
            }
            .disposed(by: disposeBag)
        output.followerCountButton
            .bind(with: self) { owner, profileResponse in
                owner.parentCoordinator?.toFollow(profileResponse, owner.me, 0)
            }
            .disposed(by: disposeBag)
        
        output.followingCountButton
            .bind(with: self) { owner, profileResponse in
                owner.parentCoordinator?.toFollow(profileResponse, owner.me, 1)
            }
            .disposed(by: disposeBag)
        
        output.userProfile
            .bind(with: self) { owner, profileResponse in
                owner.baseView.updateUI(profileResponse)
            }
            .disposed(by: disposeBag)
        
        output.followStatus
            .bind(with: self) { owner, followStatus in
                owner.baseView.updateFollowButton(followStatus)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.titleTextAttributes = nil
        navigationItem.title = "프로필 조회"
    }

    deinit {
        print(#function, "ProfileViewController ✅")
    }
}
