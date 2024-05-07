//
//  FollowViewModel.swift
//  JustBoard
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
        
        func updateFollowData(with response: ProfileResponse) {
            let items = follower ? response.followers : response.following
            followData.accept([FollowDataSection(items: items)])
            print(items, follower ? "⚠️Follower" : "⚠️Following")
        }
        
        let fetchProfile = userID.flatMap { userId in
            NetworkManager.shared.profile(userId: userId)
        }
        
        fetchProfile
            .bind(with: self) { owner, result in
                switch result {
                case .success(let profileResponse):
                    updateFollowData(with: profileResponse)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        let profileUpdate = NotificationCenter.default.rx.notification(.followRefresh)
            .withLatestFrom(userID)
            .flatMap { userId in
                NetworkManager.shared.profile(userId: userId)
            }
        
        profileUpdate
            .bind(with: self) { owner, result in
                switch result {
                case .success(let profileResponse):
                    updateFollowData(with: profileResponse)
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
