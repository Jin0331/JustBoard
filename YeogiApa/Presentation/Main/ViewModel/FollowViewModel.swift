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
    }
    
    func transform(input: Input) -> Output {

        
        return Output()
    }
}
