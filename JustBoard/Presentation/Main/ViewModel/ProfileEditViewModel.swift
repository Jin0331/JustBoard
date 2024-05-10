//
//  ProfileEditViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/9/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class ProfileEditViewModel : MainViewModelType {
    private let profileResponse : BehaviorSubject<ProfileResponse>
    var disposeBag: DisposeBag = DisposeBag()
    
    init(profileResponse: BehaviorSubject<ProfileResponse>) {
        self.profileResponse = profileResponse
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
        let addedImage : Observable<Data> // files
        let nickname : ControlProperty<String>
        let completeButton : ControlEvent<Void>
    }
    
    struct Output {
        let currentProfileResponse : Observable<ProfileResponse>
    }
    
    func transform(input: Input) -> Output {
        
        let nicknameWithImage = Observable.combineLatest(input.nickname, input.addedImage)
        
        input.completeButton
            .withLatestFrom(nicknameWithImage)
            .map {
                let nick = $0.isEmpty ? UserDefaultManager.shared.nick! : $0
                return ProfileEditRequest(nick: nick, profile: $1)
            }
            .flatMap {
                return NetworkManager.shared.profile(query: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let profileResponse):
                    print(profileResponse)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            currentProfileResponse: input.viewWillAppear
            .withLatestFrom(profileResponse)
        )
                      
    }
}
