//
//  ProfileViewModel.swift
//  YeogiApa
//
//  Created by JinwooLee on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel : MainViewModelType {
    
    private let userID : BehaviorSubject<String>
    var disposeBag: DisposeBag = DisposeBag()
    
    init(userID: BehaviorSubject<String>) {
        self.userID = userID
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
    }
    
    struct Output {
        let userProfile : PublishSubject<ProfileResponse>
    }
    
    func transform(input: Input) -> Output {
        
        let userProfile = PublishSubject<ProfileResponse>()
        
        userID
            .flatMap { userId in
                return NetworkManager.shared.profile(userId: userId)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("ProfileViewModel userProfileInquiry ✅")
                    userProfile.onNext(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            userProfile:userProfile
        )
    }
}
