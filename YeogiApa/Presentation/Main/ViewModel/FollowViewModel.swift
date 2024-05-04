//
//  FollowViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowViewModel : MainViewModelType {
    
    private let userID : BehaviorSubject<String>
    private let me : Bool
    private let follower : Bool
    private let following : Bool
    var disposeBag: DisposeBag = DisposeBag()
    
    init(userID: BehaviorSubject<String>, me : Bool, follower : Bool, following : Bool) {
        self.userID = userID
        self.me = me
        self.follower = follower
        self.following = following
    }
    
    struct Input {
        
    }
    
    struct Output {
        let followData : BehaviorRelay<[FollowDataSection]>
    }
    
    func transform(input: Input) -> Output {
        let followData = BehaviorRelay(value: [FollowDataSection]())
        
        userID
            .flatMap { userId in
                return NetworkManager.shared.profile(userId: userId)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let profileResponse):
                    
                    if owner.follower && !owner.following {
                        followData.accept([FollowDataSection(items: profileResponse.followers)])
                        print(profileResponse.followers, "⚠️Follower")
                    } else {
                        followData.accept([FollowDataSection(items: profileResponse.following)])
                        print(profileResponse.following, "⚠️Following")
                    }

                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            followData:followData
        )
    }
}
