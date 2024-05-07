//
//  FollowButtonViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowButtonViewModel : MainViewModelType {
    
    private let userID : BehaviorSubject<String>
    private let me : Bool
    var disposeBag: DisposeBag = DisposeBag()
    
    init(userID: BehaviorSubject<String>, me : Bool) {
        self.userID = userID
        self.me = me
    }
    
    struct Input {
        let followButton : ControlEvent<Void>
    }
    
    struct Output {
        let userProfile : PublishSubject<ProfileResponse>
        let followStatus : BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        
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
                    if !owner.me {
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
        input.followButton
            .withLatestFrom(followChnage)
            .debug()
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
//                        NotificationCenter.default.post(name: .boardRefresh, object: nil)
//                        NotificationCenter.default.post(name: .followRefresh, object: nil)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            userProfile:userProfile,
            followStatus: followStatus
        )
    }
}

