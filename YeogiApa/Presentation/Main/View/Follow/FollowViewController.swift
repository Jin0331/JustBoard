//
//  FollowViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController

final class FollowViewController: RxBaseViewController {

    private let baseView = FollowView()
    private let me : Bool
    private let viewModel : FollowViewModel
    var parentCoordinator : FollowCoordinator?
    private var dataSource: FollowRxDataSource!
    
    init(userID : String, me : Bool, follower : Bool, following : Bool) {
        self.me = me
        self.viewModel = FollowViewModel(userID: BehaviorSubject<String>(value: userID),
                                         me: me, follower: follower, following: following)
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        configureCollectionViewDataSource()
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = FollowViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.followData
            .bind(to: baseView.mainCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

//MARK: - RxDataSource CollectionView
extension FollowViewController {
    private func configureCollectionViewDataSource() {
        
        dataSource = FollowRxDataSource(configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            
            guard let self = self else { return UICollectionViewCell()}
            guard let myID = UserDefaultManager.shared.userId else { return UICollectionViewCell()}
            let checkUserId = item.userID == myID
            let cell: FollowCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

            let userID = BehaviorSubject<String>(value: item.userID)
            let userProfile = PublishSubject<ProfileResponse>()
            let followStatus = BehaviorSubject<Bool>(value: false)
            
            userID
                .flatMap { userId in
                    return NetworkManager.shared.profile(userId: userId)
                }
                .bind(with: self) { owner, result in
                    switch result {
                    case .success(let profileResponse):
                        let myId = UserDefaultManager.shared.userId
                        if !checkUserId {
                            if profileResponse.followers.contains(where: { follow in
                                follow.userID == myId!
                            }) {
                                followStatus.onNext(true)
                            } else {
                                followStatus.onNext(false)
                            }
                        }
                        userProfile.onNext(profileResponse)

                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
            
            //MARK: - Follow BUtton
            let followChnage = Observable.combineLatest(followStatus, userID)
            cell.followButton.rx.tap
                .withLatestFrom(followChnage)
                .flatMap{ status, user in
                    if status {
                        NetworkManager.shared.followCancel(userId: user)
                    } else {
                        NetworkManager.shared.follow(userId: user)
                    }
                }
                .bind(with: self) { owner, result in
                    switch result {
                    case .success(let followResponse):
                        followStatus.onNext(followResponse.following_status)
                        NotificationCenter.default.post(name: .boardRefresh, object: nil)
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
            
            // Profile Coordinator
            userProfile
                .bind(with: self) { owner, profileResponse in
                    cell.updateUI(profileResponse)
                }
                .disposed(by: disposeBag)
            
            followStatus
                .bind(with: self) { owner, followStatus in
                    cell.updateFollowButton(followStatus)
                }
                .disposed(by: disposeBag)
            cell.profileButton.rx.tap
                .bind(with: self) { owner, _ in
                    owner.parentCoordinator?.toProfile(userID: item.userID, me: checkUserId)
                }
                .disposed(by: disposeBag)
            
            
            return cell
        })
        
    }
}
