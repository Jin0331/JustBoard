//
//  BoardUserViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/2/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class BoardUserViewModel : MainViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    var userProfile : (userPostId:[String], userNickname:String)
    
    init(userProfile : (userPostId:[String], userNickname:String)) {
        self.userProfile = userProfile
    }
    
    struct Input {
        let viewWillAppear : ControlEvent<Bool>
    }
    
    struct Output {
        let postData : BehaviorRelay<[BoardDataSection]>
        let viewWillAppear : Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let userPostId = BehaviorSubject<[String]>(value: userProfile.userPostId)
        let postData = BehaviorRelay(value: [BoardDataSection]())
        let currentPostData = PublishSubject<[PostResponse]>()
        
        input.viewWillAppear
            .flatMap { _ in
                return NetworkManager.shared.post(query: InquiryRequest(next: InquiryRequest.InquiryRequestDefault.next,
                                                                        limit: InquiryRequest.InquiryRequestDefault.maxLimit,
                                                                        product_id: InquiryRequest.InquiryRequestDefault.productId))
            }
            .enumerated()
            .bind(with: self) { owner, result in
                switch result.element {
                case .success(let value):
                    print("BoardUser ViewWillApper ✅")
                    currentPostData.onNext(value.data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        
        //TODO: - 특정 유저 Post
        Observable.combineLatest(currentPostData, userPostId)
            .map { postData, userId in
                var specificUserPost : [PostResponse] = []
                postData.forEach {
                    if userId.contains($0.postID) {
                        specificUserPost.append($0)
                    }
                }
                return specificUserPost
            }
            .bind(with: self) { owner, postResponse in
                postData.accept([BoardDataSection(items: postResponse)])
            }
            .disposed(by: disposeBag)
        
        return Output(
            postData: postData,
            viewWillAppear: input.viewWillAppear.asDriver(onErrorJustReturn: false)
        )
    }
}
